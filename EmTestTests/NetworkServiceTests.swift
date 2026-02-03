//
//  NetworkServiceTests.swift
//  EmTestTests
//

import Testing
import Foundation
@testable import EmTest

@Suite("NetworkService Tests")
struct NetworkServiceTests {

    @Test("TodoAPIResponse decoding")
    func apiResponseDecoding() throws {
        let json = """
        {
            "todos": [
                {"id": 1, "todo": "Test task", "completed": false, "userId": 1},
                {"id": 2, "todo": "Another task", "completed": true, "userId": 2}
            ],
            "total": 2,
            "skip": 0,
            "limit": 30
        }
        """.data(using: .utf8)!

        let response = try JSONDecoder().decode(TodoAPIResponse.self, from: json)

        #expect(response.todos.count == 2)
        #expect(response.todos[0].id == 1)
        #expect(response.todos[0].todo == "Test task")
        #expect(response.todos[0].completed == false)
        #expect(response.todos[1].completed == true)
        #expect(response.total == 2)
    }

    @Test("TodoAPIItem decoding")
    func apiItemDecoding() throws {
        let json = """
        {"id": 1, "todo": "Buy groceries", "completed": true, "userId": 42}
        """.data(using: .utf8)!

        let item = try JSONDecoder().decode(TodoAPIItem.self, from: json)

        #expect(item.id == 1)
        #expect(item.todo == "Buy groceries")
        #expect(item.completed == true)
        #expect(item.userId == 42)
    }

    @Test("NetworkError descriptions")
    func errorDescriptions() {
        #expect(NetworkError.invalidURL.errorDescription == "Invalid URL")
        #expect(NetworkError.noData.errorDescription == "No data received")
        #expect(NetworkError.decodingError.errorDescription == "Failed to decode response")
    }
}
