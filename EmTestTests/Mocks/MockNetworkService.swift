//
//  MockNetworkService.swift
//  EmTestTests
//

import Foundation
@testable import EmTest

final class MockNetworkService: NetworkServiceProtocol, @unchecked Sendable {

    var mockTodos: [TodoAPIItem] = []
    var shouldFail = false

    func fetchTodos() async throws -> [TodoAPIItem] {
        if shouldFail {
            throw NetworkError.noData
        }
        return mockTodos
    }
}
