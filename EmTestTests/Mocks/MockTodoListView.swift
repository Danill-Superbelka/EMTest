//
//  MockTodoListView.swift
//  EmTestTests
//

import Foundation
@testable import EmTest

final class MockTodoListView: TodoListViewProtocol {

    var presenter: TodoListPresenterProtocol?

    var showTodosCalled = false
    var showErrorCalled = false
    var showLoadingCalled = false
    var hideLoadingCalled = false
    var updateTodoStatusCalled = false
    var removeTodoCalled = false

    var displayedTodos: [TodoItem] = []
    var errorMessage: String?
    var updatedIndex: Int?
    var updatedIsCompleted: Bool?
    var removedIndex: Int?

    func showTodos(_ todos: [TodoItem]) {
        showTodosCalled = true
        displayedTodos = todos
    }

    func showError(_ message: String) {
        showErrorCalled = true
        errorMessage = message
    }

    func showLoading() {
        showLoadingCalled = true
    }

    func hideLoading() {
        hideLoadingCalled = true
    }

    func updateTodoStatus(at index: Int, isCompleted: Bool) {
        updateTodoStatusCalled = true
        updatedIndex = index
        updatedIsCompleted = isCompleted
    }

    func removeTodo(at index: Int) {
        removeTodoCalled = true
        removedIndex = index
    }
}
