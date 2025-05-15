//
//  Country.swift
//  Takehome
//
//  Created by Olijujuan Green on 5/15/25.
//

import Foundation

struct Country: Decodable, Identifiable {
	let name: String
	let region: String
	let code: String
	let capital: String

	var id: String { code }

	private init(name: String, region: String, code: String, capital: String) {
		self.name = name
		self.region = region
		self.code = code
		self.capital = capital
	}

	static func mock() -> Country {
		Self(
			name: "United States of America",
			region: "NA",
			code: "US",
			capital: "Washington, D.C."
		)
	}
}
