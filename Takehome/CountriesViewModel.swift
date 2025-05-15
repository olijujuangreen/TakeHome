import Combine
import Foundation
import Observation

enum UserFacingError: Error, LocalizedError {
	case fetchError(String)

	var errorDescription: String? {
		switch self {
		case .fetchError(let message): return message
		}
	}
}

@MainActor
@Observable
class CountriesViewModel {
	enum ViewState: Equatable {
		static func == (lhs: ViewState, rhs: ViewState) -> Bool {
			switch (lhs, rhs) {
			case (.idle, .idle): return true
			case (.loading, .loading): return true
			case (.content(let lCountries), .content(let rCountries)): return lCountries.map(\.id) == rCountries.map(\.id)
			case (.error(let lError), .error(let rError)): return lError.localizedDescription == rError.localizedDescription
			default: return false
			}
		}

		case idle
		case loading
		case content([Country])
		case error(UserFacingError)
	}

	var viewState: ViewState = .idle
	
	var searchText: String = "" {
		didSet {
			searchTextSubject.send(searchText)
		}
	}
	
	private let countryService: CountryService
	private var cancellables = Set<AnyCancellable>()
	private let searchTextSubject = CurrentValueSubject<String, Never>("")

	init(countryService: CountryService = CountryService()) {
		self.countryService = countryService
		setupSearchDebounce()
	}

	private func setupSearchDebounce() {
		searchTextSubject
			.debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
			.removeDuplicates()
			.sink { [weak self] query in
				guard let self else { return }

				guard case .error(_) = self.viewState else {
					Task {
						let filteredCountries = await self.countryService.filterCountries(with: query)
						self.viewState = .content(filteredCountries)
					}
					return
				}
			}
			.store(in: &cancellables)
	}

	func fetchCountries() async {
		viewState = .loading
		do {
			_ = try await countryService.fetchCountries()

			let initialFilteredCountries = await countryService.filterCountries(with: searchTextSubject.value)
			viewState = .content(initialFilteredCountries)
		} catch {
			let message: String
			if let networkError = error as? NetworkError {
				switch networkError {
				case .invalidURL:
					message = "The URL for fetching countries is invalid."
				case .requestFailed(let underlyingError):
					message = "Network request failed: \(underlyingError.localizedDescription)"
				case .invalidResponse:
					message = "Received an invalid response from the server."
				case .decodingFailed(let decodingError):
					message = "Failed to decode countries data: \(decodingError.localizedDescription)"
				case .noData:
					message = "No data received from the server."
				case .statusCode(let code, _):
					message = "Server returned an error: Status \(code)."
				default:
					message = "An unknown network error occurred: \(error.localizedDescription)"
				}
			} else {
				message = "An unexpected error occurred: \(error.localizedDescription)"
			}
			viewState = .error(UserFacingError.fetchError(message))
		}
	}
}
