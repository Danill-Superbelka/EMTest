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

    func fetchTodos() async {
        do {
            let todos = try await storageService.fetchAllTodos()
            await presenter?.didFetchTodos(todos)
        } catch {
            await presenter?.didFailFetchingTodos(error: error)
        }
    }

    func loadFromAPIIfNeeded() async {
        guard storageService.isFirstLaunch() else {
            await fetchTodos()
            return
        }

        do {
            let apiItems = try await networkService.fetchTodos()

            let todos = apiItems.map { apiItem in
                TodoItem(
                    id: Int64(apiItem.id),
                    title: apiItem.todo,
                    description: "",
                    createdAt: Date(),
                    isCompleted: apiItem.completed
                )
            }

            try await storageService.saveTodos(todos)
            storageService.setFirstLaunchCompleted()
            await fetchTodos()
        } catch {
            await presenter?.didFailFetchingTodos(error: error)
        }
    }

    func toggleTodoComplete(item: TodoItem) async {
        var updatedItem = item
        updatedItem.isCompleted.toggle()

        do {
            try await storageService.updateTodo(updatedItem)
            await presenter?.didUpdateTodo(updatedItem)
        } catch {
            await presenter?.didFailOperation(error: error)
        }
    }

    func deleteTodo(id: Int64) async {
        do {
            try await storageService.deleteTodo(id: id)
            await presenter?.didDeleteTodo(id: id)
        } catch {
            await presenter?.didFailOperation(error: error)
        }
    }

    func searchTodos(query: String) async {
        do {
            let todos = try await storageService.searchTodos(query: query)
            await presenter?.didFetchTodos(todos)
        } catch {
            await presenter?.didFailFetchingTodos(error: error)
        }
    }
}
