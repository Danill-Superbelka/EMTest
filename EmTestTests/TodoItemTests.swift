//
//  TodoItemTests.swift
//  EmTestTests
//

import XCTest
@testable import EmTest

final class TodoItemTests: XCTestCase {

    func testTodoItemInitialization() {
        let date = Date()
        let todo = TodoItem(
            id: 1,
            title: "Test Task",
            description: "Test Description",
            createdAt: date,
            isCompleted: false
        )

        XCTAssertEqual(todo.id, 1)
        XCTAssertEqual(todo.title, "Test Task")
        XCTAssertEqual(todo.description, "Test Description")
        XCTAssertEqual(todo.createdAt, date)
        XCTAssertFalse(todo.isCompleted)
    }

    func testTodoItemDefaultValues() {
        let todo = TodoItem(id: 1, title: "Test")

        XCTAssertEqual(todo.id, 1)
        XCTAssertEqual(todo.title, "Test")
        XCTAssertEqual(todo.description, "")
        XCTAssertFalse(todo.isCompleted)
    }

    func testTodoItemEquality() {
        let date = Date()
        let todo1 = TodoItem(id: 1, title: "Test", description: "Desc", createdAt: date, isCompleted: false)
        let todo2 = TodoItem(id: 1, title: "Test", description: "Desc", createdAt: date, isCompleted: false)

        XCTAssertEqual(todo1, todo2)
    }

    func testTodoItemInequality() {
        let todo1 = TodoItem(id: 1, title: "Test1")
        let todo2 = TodoItem(id: 2, title: "Test2")

        XCTAssertNotEqual(todo1, todo2)
    }

    func testTodoItemMutation() {
        var todo = TodoItem(id: 1, title: "Original", isCompleted: false)

        todo.title = "Updated"
        todo.isCompleted = true

        XCTAssertEqual(todo.title, "Updated")
        XCTAssertTrue(todo.isCompleted)
    }
}
