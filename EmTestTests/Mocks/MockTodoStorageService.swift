//
//  MockTodoStorageService.swift
//  EmTestTests
//

import Foundation
@testable import EmTest

final class MockTodoStorageService: TodoStorageServiceProtocol {

    var todos: [TodoItem] = []
    var shouldFail = false
    var isFirstLaunchValue = true
    private var nextId: Int64 = 1

    func fetchAllTodos(completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        if shouldFail {
            completion(.failure(StorageError.notFound))
        } else {
            completion(.success(todos))
        }
    }

    func saveTodo(_ item: TodoItem, completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldFail {
            completion(.failure(StorageError.saveFailed))
        } else {
            todos.append(item)
            completion(.success(()))
        }
    }

    func saveTodos(_ items: [TodoItem], completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldFail {
            completion(.failure(StorageError.saveFailed))
        } else {
            todos.append(contentsOf: items)
            completion(.success(()))
        }
    }

    func updateTodo(_ item: TodoItem, completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldFail {
            completion(.failure(StorageError.saveFailed))
        } else {
            if let index = todos.firstIndex(where: { $0.id == item.id }) {
                todos[index] = item
                completion(.success(()))
            } else {
                completion(.failure(StorageError.notFound))
            }
        }
    }

    func deleteTodo(id: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldFail {
            completion(.failure(StorageError.notFound))
        } else {
            todos.removeAll { $0.id == id }
            completion(.success(()))
        }
    }

    func searchTodos(query: String, completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        if shouldFail {
            completion(.failure(StorageError.notFound))
        } else {
            let filtered = todos.filter {
                $0.title.lowercased().contains(query.lowercased()) ||
                $0.description.lowercased().contains(query.lowercased())
            }
            completion(.success(filtered))
        }
    }

    func isFirstLaunch() -> Bool {
        return isFirstLaunchValue
    }

    func setFirstLaunchCompleted() {
        isFirstLaunchValue = false
    }

    func getNextId(completion: @escaping (Int64) -> Void) {
        let id = nextId
        nextId += 1
        completion(id)
    }
}
