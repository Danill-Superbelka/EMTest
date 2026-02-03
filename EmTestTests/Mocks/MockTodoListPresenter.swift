//
//  MockTodoListPresenter.swift
//  EmTestTests
//

import Foundation
@testable import EmTest

@MainActor
final class MockTodoListPresenter: TodoListInteractorOutputProtocol {

    var didFetchTodosCalled = false
    var didFailFetchingTodosCalled = false
    var didUpdateTodoCalled = false
    var didDeleteTodoCalled = false
    var didFailOperationCalled = false

    var fetchedTodos: [TodoItem] = []
    var updatedTodo: TodoItem?
    var deletedId: Int64?
    var error: Error?

    func didFetchTodos(_ todos: [TodoItem]) {
        didFetchTodosCalled = true
        fetchedTodos = todos
    }

    func didFailFetchingTodos(error: Error) {
        didFailFetchingTodosCalled = true
        self.error = error
    }

    func didUpdateTodo(_ todo: TodoItem) {
        didUpdateTodoCalled = true
        updatedTodo = todo
    }

    func didDeleteTodo(id: Int64) {
        didDeleteTodoCalled = true
        deletedId = id
    }

    func didFailOperation(error: Error) {
        didFailOperationCalled = true
        self.error = error
    }
}
