//
//  CountryRowView.swift
//  Takehome
//
//  Created by Olijujuan Green on 5/15/25.
//

import SwiftUI

struct CountryRowView: View {
	let country: Country

	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			HStack {
				Text("\(country.name), \(country.region)")
					.font(.headline)
				Spacer()
				Text(country.code)
					.font(.subheadline)
					.foregroundColor(.gray)
			}
			Text(country.capital)
				.font(.subheadline)
		}
		.padding(.vertical, 8)
	}
}

#Preview {
	CountryRowView(country: .mock())
		.padding()
}
