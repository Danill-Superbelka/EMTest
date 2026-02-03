//
//  TodoListRouter.swift
//  EmTest
//

import UIKit

final class TodoListRouter: TodoListRouterProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        let view = TodoListViewController()
        let presenter = TodoListPresenter()
        let interactor = TodoListInteractor()
        let router = TodoListRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view

        return view
    }

    func navigateToTodoDetail(from view: TodoListViewProtocol?, todo: TodoItem?, delegate: TodoDetailDelegate?) {
        let detailVC = TodoDetailRouter.createModule(todo: todo, delegate: delegate)
        guard let sourceView = view as? UIViewController else { return }
        sourceView.navigationController?.pushViewController(detailVC, animated: true)
    }
}
