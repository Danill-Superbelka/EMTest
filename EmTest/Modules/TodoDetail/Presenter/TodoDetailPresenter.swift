//
//  TodoDetailPresenter.swift
//  EmTest
//

import Foundation

@MainActor
final class TodoDetailPresenter: TodoDetailPresenterProtocol {

    weak var view: TodoDetailViewProtocol?
    var interactor: TodoDetailInteractorInputProtocol?
    var router: TodoDetailRouterProtocol?
    weak var delegate: TodoDetailDelegate?

    private var currentTodo: TodoItem?

    func configure(todo: TodoItem?, delegate: TodoDetailDelegate?) {
        self.currentTodo = todo
        self.delegate = delegate
    }

    func viewDidLoad() {
        if let todo = currentTodo {
            view?.showTodo(todo)
        }
    }

    func isNewTodo() -> Bool {
        return currentTodo == nil
    }

    func saveTodo(title: String, description: String) {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            view?.showError(String(localized: "empty_title_error"))
            return
        }

        view?.showLoading()

        if var existingTodo = currentTodo {
            existingTodo.title = title
            existingTodo.description = description
            Task {
                await interactor?.updateTodo(existingTodo)
            }
        } else {
            Task {
                guard let nextId = await interactor?.getNextId() else { return }
                let newTodo = TodoItem(
                    id: nextId,
                    title: title,
                    description: description,
                    createdAt: Date(),
                    isCompleted: false
                )
                await interactor?.saveTodo(newTodo)
            }
        }
    }
}

// MARK: - TodoDetailInteractorOutputProtocol
extension TodoDetailPresenter: TodoDetailInteractorOutputProtocol {

    func didSaveTodo(_ todo: TodoItem) {
        view?.hideLoading()
        delegate?.didCreateTodo(todo)
        router?.navigateBack(from: view)
    }

    func didUpdateTodo(_ todo: TodoItem) {
        view?.hideLoading()
        currentTodo = todo
        delegate?.didSaveTodo(todo)
        router?.navigateBack(from: view)
    }

    func didFailSaving(error: Error) {
        view?.hideLoading()
        view?.showError(error.localizedDescription)
    }
}
