//
//  TodoStorageService.swift
//  EmTest
//

import Foundation
import CoreData

protocol TodoStorageServiceProtocol: Sendable {
    func fetchAllTodos() async throws -> [TodoItem]
    func saveTodo(_ item: TodoItem) async throws
    func saveTodos(_ items: [TodoItem]) async throws
    func updateTodo(_ item: TodoItem) async throws
    func deleteTodo(id: Int64) async throws
    func searchTodos(query: String) async throws -> [TodoItem]
    func isFirstLaunch() -> Bool
    func setFirstLaunchCompleted()
    func getNextId() async -> Int64
}

final class TodoStorageService: TodoStorageServiceProtocol, @unchecked Sendable {

    private let coreDataStack: CoreDataStack
    private let firstLaunchKey = "isFirstLaunchCompleted"

    init(coreDataStack: CoreDataStack = .shared) {
        self.coreDataStack = coreDataStack
    }

    func isFirstLaunch() -> Bool {
        return !UserDefaults.standard.bool(forKey: firstLaunchKey)
    }

    func setFirstLaunchCompleted() {
        UserDefaults.standard.set(true, forKey: firstLaunchKey)
    }

    func fetchAllTodos() async throws -> [TodoItem] {
        try await withCheckedThrowingContinuation { continuation in
            let context = coreDataStack.newBackgroundContext()
            context.perform {
                let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]

                do {
                    let entities = try context.fetch(fetchRequest)
                    let items = entities.map { $0.toTodoItem() }
                    continuation.resume(returning: items)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func saveTodo(_ item: TodoItem) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            let context = coreDataStack.newBackgroundContext()
            context.perform {
                let entity = TodoEntity(context: context)
                entity.update(from: item)

                do {
                    try context.save()
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func saveTodos(_ items: [TodoItem]) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            let context = coreDataStack.newBackgroundContext()
            context.perform {
                for item in items {
                    let entity = TodoEntity(context: context)
                    entity.update(from: item)
                }

                do {
                    try context.save()
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func updateTodo(_ item: TodoItem) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            let context = coreDataStack.newBackgroundContext()
            context.perform {
                let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %lld", item.id)

                do {
                    let results = try context.fetch(fetchRequest)
                    if let entity = results.first {
                        entity.update(from: item)
                        try context.save()
                        continuation.resume()
                    } else {
                        continuation.resume(throwing: StorageError.notFound)
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func deleteTodo(id: Int64) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            let context = coreDataStack.newBackgroundContext()
            context.perform {
                let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %lld", id)

                do {
                    let results = try context.fetch(fetchRequest)
                    if let entity = results.first {
                        context.delete(entity)
                        try context.save()
                        continuation.resume()
                    } else {
                        continuation.resume(throwing: StorageError.notFound)
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func searchTodos(query: String) async throws -> [TodoItem] {
        try await withCheckedThrowingContinuation { continuation in
            let context = coreDataStack.newBackgroundContext()
            context.perform {
                let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()

                if !query.isEmpty {
                    fetchRequest.predicate = NSPredicate(
                        format: "title CONTAINS[cd] %@ OR todoDescription CONTAINS[cd] %@",
                        query, query
                    )
                }
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]

                do {
                    let entities = try context.fetch(fetchRequest)
                    let items = entities.map { $0.toTodoItem() }
                    continuation.resume(returning: items)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func getNextId() async -> Int64 {
        await withCheckedContinuation { continuation in
            let context = coreDataStack.newBackgroundContext()
            context.perform {
                let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
                fetchRequest.fetchLimit = 1

                do {
                    let results = try context.fetch(fetchRequest)
                    let nextId = (results.first?.id ?? 0) + 1
                    continuation.resume(returning: nextId)
                } catch {
                    continuation.resume(returning: 1)
                }
            }
        }
    }
}

enum StorageError: Error, LocalizedError {
    case notFound
    case saveFailed

    var errorDescription: String? {
        switch self {
        case .notFound:
            return "Item not found"
        case .saveFailed:
            return "Failed to save item"
        }
    }
}
