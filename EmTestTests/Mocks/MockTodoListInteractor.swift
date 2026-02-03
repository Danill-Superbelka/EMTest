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

    func fetchTodos() async {
        fetchTodosCalled = true
    }

    func loadFromAPIIfNeeded() async {
        loadFromAPIIfNeededCalled = true
    }

    func toggleTodoComplete(item: TodoItem) async {
        toggleTodoCompleteCalled = true
        toggledItem = item
    }

    func deleteTodo(id: Int64) async {
        deleteTodoCalled = true
        deletedId = id
    }

    func searchTodos(query: String) async {
        searchTodosCalled = true
        searchQuery = query
    }
}
