//
//  CountriesView.swift
//  Takehome
//
//  Created by Olijujuan Green on 5/15/25.
//

import SwiftUI

struct CountriesView: View {
	@State private var viewModel = CountriesViewModel()

	var body: some View {
		currentView
			.task {
				if case .idle = viewModel.viewState {
					await viewModel.fetchCountries()
				}
			}
	}

	// MARK: - View Builders

	@ViewBuilder
	private var currentView: some View {
		switch viewModel.viewState {
		case .idle:
			idleStatusView
		case .loading:
			loadingStatusView
		case .content(let countries):
			countriesListView(countries: countries)
		case .error(let userFacingError):
			errorStatusView(error: userFacingError)
		}
	}

	@ViewBuilder
	private var idleStatusView: some View {
		ProgressView("Initializing...")
			.frame(maxWidth: .infinity, maxHeight: .infinity)
	}

	@ViewBuilder
	private var loadingStatusView: some View {
		ProgressView("Loading countries...")
			.frame(maxWidth: .infinity, maxHeight: .infinity)
	}

	@ViewBuilder
	private func countriesListView(countries: [Country]) -> some View {
		if countries.isEmpty {
			if viewModel.searchText.isEmpty {
				Text("No countries available.")
					.font(.headline)
					.foregroundColor(.secondary)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
			} else {
				Text("No countries found for \"\(viewModel.searchText)\".")
					.font(.headline)
					.foregroundColor(.secondary)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
			}
		} else {
			VStack(spacing: .zero) {
				Text("Countries")
					.font(.largeTitle)
					.fontWeight(.bold)
					.padding(.vertical, 8)
					.padding(.horizontal)
					.frame(maxWidth: .infinity, alignment: .leading)

				SearchBarView(
					text: $viewModel.searchText,
					prompt: "Search by name or capital"
				)
				.padding()

				List(countries) { country in
					CountryRowView(country: country)
				}
			}
		}
	}

	@ViewBuilder
	private func errorStatusView(error: UserFacingError) -> some View {
		VStack(spacing: 16) {
			Image(systemName: "exclamationmark.triangle.fill")
				.font(.system(size: 50))
				.foregroundColor(.red)

			Text("Something Went Wrong")
				.font(.title2)
				.fontWeight(.semibold)

			Text(error.localizedDescription)
				.font(.callout)
				.foregroundColor(.secondary)
				.multilineTextAlignment(.center)
				.padding(.horizontal)

			Button("Retry") {
				Task {
					await viewModel.fetchCountries()
				}
			}
			.buttonStyle(.borderedProminent)
			.padding(.top)
		}
		.padding()
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}

#Preview {
	CountriesView()
}
