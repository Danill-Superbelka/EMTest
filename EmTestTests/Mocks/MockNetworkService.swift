//
//  MockNetworkService.swift
//  EmTestTests
//

import Foundation
@testable import EmTest

final class MockNetworkService: NetworkServiceProtocol, @unchecked Sendable {

    var mockTodos: [TodoAPIItem] = []
    var shouldFail = false

    func fetchTodos(completion: @escaping (Result<[TodoAPIItem], Error>) -> Void) {
        if shouldFail {
            completion(.failure(NetworkError.noData))
        } else {
            completion(.success(mockTodos))
        }
    }
}
