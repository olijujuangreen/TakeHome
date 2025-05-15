//
//  Country.swift
//  Takehome
//
//  Created by Olijujuan Green on 5/15/25.
//

import Foundation

struct Country: Codable {
	let capital: String
	let code: String
	let currency: Currency
	let flagImageUrl: String
	let language: Language
	let name: String
	let region: String

	enum CodingKeys: String, CodingKey {
		case capital
		case code
		case currency
		case flagImageUrl = "flag"
		case language
		case name
		case region
	}

	private init(
		capital: String,
		code: String,
		currency: Currency,
		flagImageUrl: String,
		language: Language,
		name: String,
		region: String
	) {
		self.capital = capital
		self.code = code
		self.currency = currency
		self.flagImageUrl = flagImageUrl
		self.language = language
		self.name = name
		self.region = region
	}
}

struct Currency: Codable {
	let code: String
	let name: String
	let symbol: String
}

struct Language: Codable {
	let code: String
	let name: String
}
