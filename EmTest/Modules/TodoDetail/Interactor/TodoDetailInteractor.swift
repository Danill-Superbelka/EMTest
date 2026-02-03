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

    func saveTodo(_ item: TodoItem) async {
        do {
            try await storageService.saveTodo(item)
            await presenter?.didSaveTodo(item)
        } catch {
            await presenter?.didFailSaving(error: error)
        }
    }

    func updateTodo(_ item: TodoItem) async {
        do {
            try await storageService.updateTodo(item)
            await presenter?.didUpdateTodo(item)
        } catch {
            await presenter?.didFailSaving(error: error)
        }
    }

    func getNextId() async -> Int64 {
        await storageService.getNextId()
    }
}
