//
//  TodoItemTests.swift
//  EmTestTests
//

import Testing
import Foundation
@testable import EmTest

@Suite("TodoItem Tests")
struct TodoItemTests {

    @Test("Initialization with all parameters")
    func initialization() {
        let date = Date()
        let todo = TodoItem(
            id: 1,
            title: "Test Task",
            description: "Test Description",
            createdAt: date,
            isCompleted: false
        )

        #expect(todo.id == 1)
        #expect(todo.title == "Test Task")
        #expect(todo.description == "Test Description")
        #expect(todo.createdAt == date)
        #expect(todo.isCompleted == false)
    }

    @Test("Default values")
    func defaultValues() {
        let todo = TodoItem(id: 1, title: "Test")

        #expect(todo.id == 1)
        #expect(todo.title == "Test")
        #expect(todo.description == "")
        #expect(todo.isCompleted == false)
    }

    @Test("Equality")
    func equality() {
        let date = Date()
        let todo1 = TodoItem(id: 1, title: "Test", description: "Desc", createdAt: date, isCompleted: false)
        let todo2 = TodoItem(id: 1, title: "Test", description: "Desc", createdAt: date, isCompleted: false)

        #expect(todo1 == todo2)
    }

    @Test("Inequality")
    func inequality() {
        let todo1 = TodoItem(id: 1, title: "Test1")
        let todo2 = TodoItem(id: 2, title: "Test2")

        #expect(todo1 != todo2)
    }

    @Test("Mutation")
    func mutation() {
        var todo = TodoItem(id: 1, title: "Original", isCompleted: false)

        todo.title = "Updated"
        todo.isCompleted = true

        #expect(todo.title == "Updated")
        #expect(todo.isCompleted == true)
    }
}
