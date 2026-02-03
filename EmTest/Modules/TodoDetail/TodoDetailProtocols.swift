//
//  TodoDetailProtocols.swift
//  EmTest
//

import UIKit

// MARK: - View
@MainActor
protocol TodoDetailViewProtocol: AnyObject {
    var presenter: TodoDetailPresenterProtocol? { get set }

    func showTodo(_ todo: TodoItem)
    func showError(_ message: String)
    func showLoading()
    func hideLoading()
}

// MARK: - Presenter
@MainActor
protocol TodoDetailPresenterProtocol: AnyObject {
    var view: TodoDetailViewProtocol? { get set }
    var interactor: TodoDetailInteractorInputProtocol? { get set }
    var router: TodoDetailRouterProtocol? { get set }

    func viewDidLoad()
    func saveTodo(title: String, description: String)
    func isNewTodo() -> Bool
}

// MARK: - Interactor Input
protocol TodoDetailInteractorInputProtocol: AnyObject {
    var presenter: TodoDetailInteractorOutputProtocol? { get set }

    func saveTodo(_ item: TodoItem) async
    func updateTodo(_ item: TodoItem) async
    func getNextId() async -> Int64
}

// MARK: - Interactor Output
@MainActor
protocol TodoDetailInteractorOutputProtocol: AnyObject {
    func didSaveTodo(_ todo: TodoItem)
    func didUpdateTodo(_ todo: TodoItem)
    func didFailSaving(error: Error)
}

// MARK: - Router
protocol TodoDetailRouterProtocol: AnyObject {
    static func createModule(todo: TodoItem?, delegate: TodoDetailDelegate?) -> UIViewController
    func navigateBack(from view: TodoDetailViewProtocol?)
}
