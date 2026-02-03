//
//  MockTodoListInteractor.swift
//  EmTestTests
//

import Foundation
@testable import EmTest

@MainActor
final class MockTodoListInteractor: TodoListInteractorInputProtocol {

    weak var presenter: TodoListInteractorOutputProtocol?

    var fetchTodosCalled = false
    var loadFromAPIIfNeededCalled = false
    var toggleTodoCompleteCalled = false
    var deleteTodoCalled = false
    var searchTodosCalled = false

    var toggledItem: TodoItem?
    var deletedId: Int64?
    var searchQuery: String?

    func fetchTodos() {
        fetchTodosCalled = true
    }

    func loadFromAPIIfNeeded() {
        loadFromAPIIfNeededCalled = true
    }

    func toggleTodoComplete(item: TodoItem) {
        toggleTodoCompleteCalled = true
        toggledItem = item
    }

    func deleteTodo(id: Int64) {
        deleteTodoCalled = true
        deletedId = id
    }

    func searchTodos(query: String) {
        searchTodosCalled = true
        searchQuery = query
    }
}
