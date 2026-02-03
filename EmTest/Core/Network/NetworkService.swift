//
//  NetworkService.swift
//  EmTest
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchTodos(completion: @escaping (Result<[TodoAPIItem], Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {

    private let baseURL = "https://dummyjson.com"
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchTodos(completion: @escaping (Result<[TodoAPIItem], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/todos") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(TodoAPIResponse.self, from: data)
                completion(.success(response.todos))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
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
