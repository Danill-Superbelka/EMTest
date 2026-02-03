//
//  TodoDetailRouter.swift
//  EmTest
//

import UIKit

final class TodoDetailRouter: TodoDetailRouterProtocol {

    weak var viewController: UIViewController?

    static func createModule(todo: TodoItem?, delegate: TodoDetailDelegate?) -> UIViewController {
        let view = TodoDetailViewController()
        let presenter = TodoDetailPresenter()
        let interactor = TodoDetailInteractor()
        let router = TodoDetailRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        presenter.configure(todo: todo, delegate: delegate)
        interactor.presenter = presenter
        router.viewController = view

        return view
    }

    func navigateBack(from view: TodoDetailViewProtocol?) {
        guard let sourceView = view as? UIViewController else { return }
        sourceView.navigationController?.popViewController(animated: true)
    }
}
