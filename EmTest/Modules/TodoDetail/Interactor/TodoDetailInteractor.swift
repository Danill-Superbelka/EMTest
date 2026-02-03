//
//  TodoDetailInteractor.swift
//  EmTest
//

import Foundation

final class TodoDetailInteractor: TodoDetailInteractorInputProtocol {

    weak var presenter: TodoDetailInteractorOutputProtocol?

    private let storageService: TodoStorageServiceProtocol

    init(storageService: TodoStorageServiceProtocol = TodoStorageService()) {
        self.storageService = storageService
    }

    func saveTodo(_ item: TodoItem) {
        storageService.saveTodo(item) { [weak self] result in
            switch result {
            case .success:
                self?.presenter?.didSaveTodo(item)
            case .failure(let error):
                self?.presenter?.didFailSaving(error: error)
            }
        }
    }

    func updateTodo(_ item: TodoItem) {
        storageService.updateTodo(item) { [weak self] result in
            switch result {
            case .success:
                self?.presenter?.didUpdateTodo(item)
            case .failure(let error):
                self?.presenter?.didFailSaving(error: error)
            }
        }
    }

    func getNextId(completion: @escaping (Int64) -> Void) {
        storageService.getNextId(completion: completion)
    }
}
