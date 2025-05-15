//
//  NetworkError.swift
//  Takehome
//
//  Created by Olijujuan Green on // Assuming a creation date or use a new one.
//

import Foundation

enum NetworkError: Error {
	case invalidURL
	case requestFailed(Error)
	case invalidResponse
	case decodingFailed(Error)
	case noData
	case unknownError
	case statusCode(Int, Data) // Ensure this matches usage, expecting Data not Data?
}
