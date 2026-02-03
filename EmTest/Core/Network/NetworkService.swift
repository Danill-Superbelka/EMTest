//
//  NetworkService.swift
//  EmTest
//

import Foundation

protocol NetworkServiceProtocol: Sendable {
    func fetchTodos() async throws -> [TodoAPIItem]
}

final class NetworkService: NetworkServiceProtocol, Sendable {

    private let baseURL = "https://dummyjson.com"
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchTodos() async throws -> [TodoAPIItem] {
        guard let url = URL(string: "\(baseURL)/todos") else {
            throw NetworkError.invalidURL
        }

        let (data, _) = try await session.data(from: url)

        let response = try JSONDecoder().decode(TodoAPIResponse.self, from: data)
        return response.todos
    }
}

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode response"
        }
    }
}
