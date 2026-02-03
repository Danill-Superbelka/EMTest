//
//  TodoListPresenter.swift
//  EmTest
//

import Foundation

@MainActor
final class TodoListPresenter: TodoListPresenterProtocol {

    weak var view: TodoListViewProtocol?
    var interactor: TodoListInteractorInputProtocol?
    var router: TodoListRouterProtocol?

    private var todos: [TodoItem] = []
    private var currentSearchQuery: String = ""

    func viewDidLoad() {
        view?.showLoading()
        Task {
            await interactor?.loadFromAPIIfNeeded()
        }
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
        Task {
            await interactor?.toggleTodoComplete(item: todo)
        }
    }

    func didTapDelete(at index: Int) {
        guard index < todos.count else { return }
        let todo = todos[index]
        Task {
            await interactor?.deleteTodo(id: todo.id)
        }
    }

    func didSearch(query: String) {
        currentSearchQuery = query
        view?.showLoading()
        Task {
            await interactor?.searchTodos(query: query)
        }
    }

    func didPullToRefresh() {
        Task {
            if currentSearchQuery.isEmpty {
                await interactor?.fetchTodos()
            } else {
                await interactor?.searchTodos(query: currentSearchQuery)
            }
        }
    }

    func numberOfTodos() -> Int {
        return todos.count
    }

    func todo(at index: Int) -> TodoItem? {
        guard index < todos.count else { return nil }
        return todos[index]
    }

    private func updateEmptyState() {
        if todos.isEmpty {
            view?.showEmptyState()
        } else {
            view?.hideEmptyState()
        }
    }
}

// MARK: - TodoListInteractorOutputProtocol
extension TodoListPresenter: TodoListInteractorOutputProtocol {

    func didFetchTodos(_ todos: [TodoItem]) {
        self.todos = todos
        view?.hideLoading()
        view?.endRefreshing()
        view?.showTodos(todos)
        updateEmptyState()
    }

    func didFailFetchingTodos(error: Error) {
        view?.hideLoading()
        view?.endRefreshing()
        view?.showError(error.localizedDescription)
        updateEmptyState()
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
            updateEmptyState()
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
        Task {
            if currentSearchQuery.isEmpty {
                await interactor?.fetchTodos()
            } else {
                await interactor?.searchTodos(query: currentSearchQuery)
            }
        }
    }

    func didCreateTodo(_ todo: TodoItem) {
        Task {
            if currentSearchQuery.isEmpty {
                await interactor?.fetchTodos()
            } else {
                await interactor?.searchTodos(query: currentSearchQuery)
            }
        }
    }
}
