//
//  TodoListPresenter.swift
//  EmTest
//

import Foundation

final class TodoListPresenter: TodoListPresenterProtocol {

    weak var view: TodoListViewProtocol?
    var interactor: TodoListInteractorInputProtocol?
    var router: TodoListRouterProtocol?

    private var todos: [TodoItem] = []
    private var currentSearchQuery: String = ""

    func viewDidLoad() {
        view?.showLoading()
        interactor?.loadFromAPIIfNeeded()
    }

    func didSelectTodo(at index: Int) {
        guard index < todos.count else { return }
        let todo = todos[index]
        router?.navigateToTodoDetail(from: view, todo: todo, delegate: self)
    }

    func didTapAddTodo() {
        router?.navigateToTodoDetail(from: view, todo: nil, delegate: self)
    }

    func didTapToggleComplete(at index: Int) {
        guard index < todos.count else { return }
        let todo = todos[index]
        interactor?.toggleTodoComplete(item: todo)
    }

    func didTapDelete(at index: Int) {
        guard index < todos.count else { return }
        let todo = todos[index]
        interactor?.deleteTodo(id: todo.id)
    }

    func didSearch(query: String) {
        currentSearchQuery = query
        view?.showLoading()
        interactor?.searchTodos(query: query)
    }

    func numberOfTodos() -> Int {
        return todos.count
    }

    func todo(at index: Int) -> TodoItem? {
        guard index < todos.count else { return nil }
        return todos[index]
    }
}

// MARK: - TodoListInteractorOutputProtocol
extension TodoListPresenter: TodoListInteractorOutputProtocol {

    func didFetchTodos(_ todos: [TodoItem]) {
        self.todos = todos
        view?.hideLoading()
        view?.showTodos(todos)
    }

    func didFailFetchingTodos(error: Error) {
        view?.hideLoading()
        view?.showError(error.localizedDescription)
    }

    func didUpdateTodo(_ todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index] = todo
            view?.updateTodoStatus(at: index, isCompleted: todo.isCompleted)
        }
    }

    func didDeleteTodo(id: Int64) {
        if let index = todos.firstIndex(where: { $0.id == id }) {
            todos.remove(at: index)
            view?.removeTodo(at: index)
        }
    }

    func didFailOperation(error: Error) {
        view?.showError(error.localizedDescription)
    }
}

// MARK: - TodoDetailDelegate
extension TodoListPresenter: TodoDetailDelegate {

    func didSaveTodo(_ todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index] = todo
        }
        if currentSearchQuery.isEmpty {
            interactor?.fetchTodos()
        } else {
            interactor?.searchTodos(query: currentSearchQuery)
        }
    }

    func didCreateTodo(_ todo: TodoItem) {
        if currentSearchQuery.isEmpty {
            interactor?.fetchTodos()
        } else {
            interactor?.searchTodos(query: currentSearchQuery)
        }
    }
}
