//
//  MockTodoStorageService.swift
//  EmTestTests
//

import Foundation
@testable import EmTest

final class MockTodoStorageService: TodoStorageServiceProtocol, @unchecked Sendable {

    var todos: [TodoItem] = []
    var shouldFail = false
    var isFirstLaunchValue = true
    private var nextId: Int64 = 1

    func fetchAllTodos() async throws -> [TodoItem] {
        if shouldFail {
            throw StorageError.notFound
        }
        return todos
    }

    func saveTodo(_ item: TodoItem) async throws {
        if shouldFail {
            throw StorageError.saveFailed
        }
        todos.append(item)
    }

    func saveTodos(_ items: [TodoItem]) async throws {
        if shouldFail {
            throw StorageError.saveFailed
        }
        todos.append(contentsOf: items)
    }

    func updateTodo(_ item: TodoItem) async throws {
        if shouldFail {
            throw StorageError.saveFailed
        }
        if let index = todos.firstIndex(where: { $0.id == item.id }) {
            todos[index] = item
        } else {
            throw StorageError.notFound
        }
    }

    func deleteTodo(id: Int64) async throws {
        if shouldFail {
            throw StorageError.notFound
        }
        todos.removeAll { $0.id == id }
    }

    func searchTodos(query: String) async throws -> [TodoItem] {
        if shouldFail {
            throw StorageError.notFound
        }
        return todos.filter {
            $0.title.lowercased().contains(query.lowercased()) ||
            $0.description.lowercased().contains(query.lowercased())
        }
    }

    func isFirstLaunch() -> Bool {
        return isFirstLaunchValue
    }

    func setFirstLaunchCompleted() {
        isFirstLaunchValue = false
    }

    func getNextId() async -> Int64 {
        let id = nextId
        nextId += 1
        return id
    }
}
