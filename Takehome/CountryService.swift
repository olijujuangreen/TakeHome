//
//  CountryService.swift
//  Takehome
//
//  Created by Olijujuan Green on 5/15/25
//

import Foundation
import Combine

actor CountryService: NetworkService {
	let urlString = "https://gist.githubusercontent.com/peymano-wmt/32dcb892b06648910ddd40406e37fdab/raw/db25946fd77c5873b0303b858e861ce724e0dcd0/countries.json"
    private var allCountries: [Country] = []

    func fetchCountries() async throws -> [Country] {
		guard let url = URL(string: urlString) else {
			throw NetworkError.invalidURL
		}

        let urlRequest = URLRequest(url: url)
		let fetchedCountries: [Country] = try await request(urlRequest)
        self.allCountries = fetchedCountries
        return fetchedCountries
    }

    func filterCountries(with query: String) -> [Country] {
		guard !query.isEmpty else {
			return allCountries
		}

		let lowercasedQuery = query.lowercased()
		return allCountries.filter { country in
			country.name.lowercased().contains(lowercasedQuery) ||
			country.capital.lowercased().contains(lowercasedQuery)
		}
    }
}
