//
//  NetworkError.swift
//  Takehome
//
//  Created by Olijujuan Green on 5/15/25
//

import Foundation

enum NetworkError: Error {
	case invalidURL
	case requestFailed(Error)
	case invalidResponse
	case decodingFailed(Error)
	case noData
	case unknownError
	case statusCode(Int, Data)
}
