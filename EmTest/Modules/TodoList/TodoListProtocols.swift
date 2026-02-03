//
//  TodoListProtocols.swift
//  EmTest
//

import UIKit

// MARK: - View
protocol TodoListViewProtocol: AnyObject {
    var presenter: TodoListPresenterProtocol? { get set }

    func showTodos(_ todos: [TodoItem])
    func showError(_ message: String)
    func showLoading()
    func hideLoading()
    func updateTodoStatus(at index: Int, isCompleted: Bool)
    func removeTodo(at index: Int)
}

// MARK: - Presenter
protocol TodoListPresenterProtocol: AnyObject {
    var view: TodoListViewProtocol? { get set }
    var interactor: TodoListInteractorInputProtocol? { get set }
    var router: TodoListRouterProtocol? { get set }

    func viewDidLoad()
    func didSelectTodo(at index: Int)
    func didTapAddTodo()
    func didTapToggleComplete(at index: Int)
    func didTapDelete(at index: Int)
    func didSearch(query: String)
    func numberOfTodos() -> Int
    func todo(at index: Int) -> TodoItem?
}

// MARK: - Interactor Input
protocol TodoListInteractorInputProtocol: AnyObject {
    var presenter: TodoListInteractorOutputProtocol? { get set }

    func fetchTodos()
    func loadFromAPIIfNeeded()
    func toggleTodoComplete(item: TodoItem)
    func deleteTodo(id: Int64)
    func searchTodos(query: String)
}

// MARK: - Interactor Output
protocol TodoListInteractorOutputProtocol: AnyObject {
    func didFetchTodos(_ todos: [TodoItem])
    func didFailFetchingTodos(error: Error)
    func didUpdateTodo(_ todo: TodoItem)
    func didDeleteTodo(id: Int64)
    func didFailOperation(error: Error)
}

// MARK: - Router
protocol TodoListRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func navigateToTodoDetail(from view: TodoListViewProtocol?, todo: TodoItem?, delegate: TodoDetailDelegate?)
}

// MARK: - Delegate
protocol TodoDetailDelegate: AnyObject {
    func didSaveTodo(_ todo: TodoItem)
    func didCreateTodo(_ todo: TodoItem)
}
