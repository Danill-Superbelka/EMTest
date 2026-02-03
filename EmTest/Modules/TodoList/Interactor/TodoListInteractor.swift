//
//  TodoListInteractor.swift
//  EmTest
//

import Foundation

final class TodoListInteractor: TodoListInteractorInputProtocol {

    weak var presenter: TodoListInteractorOutputProtocol?

    private let storageService: TodoStorageServiceProtocol
    private let networkService: NetworkServiceProtocol

    init(storageService: TodoStorageServiceProtocol = TodoStorageService(),
         networkService: NetworkServiceProtocol = NetworkService()) {
        self.storageService = storageService
        self.networkService = networkService
    }

    func fetchTodos() {
        storageService.fetchAllTodos { [weak self] result in
            switch result {
            case .success(let todos):
                self?.presenter?.didFetchTodos(todos)
            case .failure(let error):
                self?.presenter?.didFailFetchingTodos(error: error)
            }
        }
    }

    func loadFromAPIIfNeeded() {
        guard storageService.isFirstLaunch() else {
            fetchTodos()
            return
        }

        networkService.fetchTodos { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let apiItems):
                let todos = apiItems.map { apiItem in
                    TodoItem(
                        id: Int64(apiItem.id),
                        title: apiItem.todo,
                        description: "",
                        createdAt: Date(),
                        isCompleted: apiItem.completed
                    )
                }

                self.storageService.saveTodos(todos) { [weak self] saveResult in
                    switch saveResult {
                    case .success:
                        self?.storageService.setFirstLaunchCompleted()
                        self?.fetchTodos()
                    case .failure(let error):
                        self?.presenter?.didFailFetchingTodos(error: error)
                    }
                }

            case .failure(let error):
                self.presenter?.didFailFetchingTodos(error: error)
            }
        }
    }

    func toggleTodoComplete(item: TodoItem) {
        var updatedItem = item
        updatedItem.isCompleted.toggle()

        storageService.updateTodo(updatedItem) { [weak self] result in
            switch result {
            case .success:
                self?.presenter?.didUpdateTodo(updatedItem)
            case .failure(let error):
                self?.presenter?.didFailOperation(error: error)
            }
        }
    }

    func deleteTodo(id: Int64) {
        storageService.deleteTodo(id: id) { [weak self] result in
            switch result {
            case .success:
                self?.presenter?.didDeleteTodo(id: id)
            case .failure(let error):
                self?.presenter?.didFailOperation(error: error)
            }
        }
    }

    func searchTodos(query: String) {
        storageService.searchTodos(query: query) { [weak self] result in
            switch result {
            case .success(let todos):
                self?.presenter?.didFetchTodos(todos)
            case .failure(let error):
                self?.presenter?.didFailFetchingTodos(error: error)
            }
        }
    }
}
