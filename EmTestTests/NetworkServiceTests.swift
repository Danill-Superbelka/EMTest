//
//  NetworkServiceTests.swift
//  EmTestTests
//

import XCTest
@testable import EmTest

final class NetworkServiceTests: XCTestCase {

    func testTodoAPIResponseDecoding() {
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

        let decoder = JSONDecoder()
        let response = try? decoder.decode(TodoAPIResponse.self, from: json)

        XCTAssertNotNil(response)
        XCTAssertEqual(response?.todos.count, 2)
        XCTAssertEqual(response?.todos[0].id, 1)
        XCTAssertEqual(response?.todos[0].todo, "Test task")
        XCTAssertFalse(response?.todos[0].completed ?? true)
        XCTAssertTrue(response?.todos[1].completed ?? false)
        XCTAssertEqual(response?.total, 2)
    }

    func testTodoAPIItemDecoding() {
        let json = """
        {"id": 1, "todo": "Buy groceries", "completed": true, "userId": 42}
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let item = try? decoder.decode(TodoAPIItem.self, from: json)

        XCTAssertNotNil(item)
        XCTAssertEqual(item?.id, 1)
        XCTAssertEqual(item?.todo, "Buy groceries")
        XCTAssertTrue(item?.completed ?? false)
        XCTAssertEqual(item?.userId, 42)
    }

    func testNetworkErrorDescriptions() {
        XCTAssertEqual(NetworkError.invalidURL.errorDescription, "Invalid URL")
        XCTAssertEqual(NetworkError.noData.errorDescription, "No data received")
        XCTAssertEqual(NetworkError.decodingError.errorDescription, "Failed to decode response")
    }
}
