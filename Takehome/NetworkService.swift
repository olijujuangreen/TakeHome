//
//  NetworkService.swift
//  TakeHome
//
//  Created by Olijujuan Green on 2/19/24.
//

import Foundation

protocol NetworkService {
	func request<T: Decodable>(_ request: URLRequest) async throws -> T
	func requestData(_ request: URLRequest) async throws -> Data
}

extension NetworkService {
	/// Sends an HTTP request and decodes the response into the specified type.
	///
	/// - Parameter request: A `URLRequest` representing the HTTP request to be sent.
	/// - Returns: A decoded object of type `T` conforming to `Decodable`.
	/// - Throws:
	///   - `NetworkError.invalidResponse`: If the response is not an HTTPURLResponse.
	///   - `NetworkError.statusCode`: If the HTTP response status code indicates a failure.
	///   - `NetworkError.decodingFailed`: If decoding the response data into type `T` fails.
	///   - `NetworkError.requestFailed`: If the request fails with an underlying error.
	func request<T: Decodable>(_ request: URLRequest) async throws -> T {
		do {
			let (data, response) = try await URLSession.shared.data(for: request)

			guard let httpResponse = response as? HTTPURLResponse else {
				throw NetworkError.invalidResponse
			}

			guard (200...299).contains(httpResponse.statusCode) else {
				throw NetworkError.statusCode(httpResponse.statusCode, data)
			}

			return try decodedResponse(data)
		} catch {
			throw NetworkError.requestFailed(error)
		}
	}

	/// Sends an HTTP request and returns the raw response data.
	///
	/// - Parameter request: A `URLRequest` representing the HTTP request to be sent.
	/// - Returns: Raw `Data` from the server's response.
	/// - Throws:
	///   - `NetworkError.invalidResponse`: If the response is not an HTTPURLResponse.
	///   - `NetworkError.statusCode`: If the HTTP response status code indicates a failure.
	///   - `NetworkError.requestFailed`: If the request fails with an underlying error.
	func requestData(_ request: URLRequest) async throws -> Data {
		do {
			let (data, response) = try await URLSession.shared.data(for: request)

			guard let httpResponse = response as? HTTPURLResponse else {
				throw NetworkError.invalidResponse
			}

			guard (200...299).contains(httpResponse.statusCode) else {
				throw NetworkError.statusCode(httpResponse.statusCode, data)
			}

			return data
		} catch {
			throw NetworkError.requestFailed(error)
		}
	}

	/// Decodes raw response data into the specified type.
	///
	/// - Parameter data: The raw `Data` received from the server's response.
	/// - Returns: A decoded object of type `T` conforming to `Decodable`.
	/// - Throws:
	///   - `NetworkError.decodingFailed`: If decoding the response data into type `T` fails.
	private func decodedResponse<T: Decodable>(_ data: Data) throws -> T {
		do {
			return try JSONDecoder().decode(T.self, from: data)
		} catch {
			throw NetworkError.decodingFailed(error)
		}
	}
}
