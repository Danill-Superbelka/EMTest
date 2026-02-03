//
//  TodoStorageService.swift
//  EmTest
//

import Foundation
import CoreData

protocol TodoStorageServiceProtocol {
    func fetchAllTodos(completion: @escaping (Result<[TodoItem], Error>) -> Void)
    func saveTodo(_ item: TodoItem, completion: @escaping (Result<Void, Error>) -> Void)
    func updateTodo(_ item: TodoItem, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteTodo(id: Int64, completion: @escaping (Result<Void, Error>) -> Void)
    func searchTodos(query: String, completion: @escaping (Result<[TodoItem], Error>) -> Void)
    func isFirstLaunch() -> Bool
    func setFirstLaunchCompleted()
    func getNextId(completion: @escaping (Int64) -> Void)
    func saveTodos(_ items: [TodoItem], completion: @escaping (Result<Void, Error>) -> Void)
}

final class TodoStorageService: TodoStorageServiceProtocol {

    private let coreDataStack: CoreDataStack
    private let operationQueue: OperationQueue
    private let firstLaunchKey = "isFirstLaunchCompleted"

    init(coreDataStack: CoreDataStack = .shared) {
        self.coreDataStack = coreDataStack
        self.operationQueue = OperationQueue()
        self.operationQueue.maxConcurrentOperationCount = 1
        self.operationQueue.qualityOfService = .userInitiated
    }

    func isFirstLaunch() -> Bool {
        return !UserDefaults.standard.bool(forKey: firstLaunchKey)
    }

    func setFirstLaunchCompleted() {
        UserDefaults.standard.set(true, forKey: firstLaunchKey)
    }

    func fetchAllTodos(completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        let operation = BlockOperation { [weak self] in
            guard let self = self else { return }

            let context = self.coreDataStack.newBackgroundContext()
            context.performAndWait {
                let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]

                do {
                    let entities = try context.fetch(fetchRequest)
                    let items = entities.map { $0.toTodoItem() }
                    DispatchQueue.main.async {
                        completion(.success(items))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
        operationQueue.addOperation(operation)
    }

    func saveTodo(_ item: TodoItem, completion: @escaping (Result<Void, Error>) -> Void) {
        let operation = BlockOperation { [weak self] in
            guard let self = self else { return }

            let context = self.coreDataStack.newBackgroundContext()
            context.performAndWait {
                let entity = TodoEntity(context: context)
                entity.update(from: item)

                do {
                    try context.save()
                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
        operationQueue.addOperation(operation)
    }

    func saveTodos(_ items: [TodoItem], completion: @escaping (Result<Void, Error>) -> Void) {
        let operation = BlockOperation { [weak self] in
            guard let self = self else { return }

            let context = self.coreDataStack.newBackgroundContext()
            context.performAndWait {
                for item in items {
                    let entity = TodoEntity(context: context)
                    entity.update(from: item)
                }

                do {
                    try context.save()
                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
        operationQueue.addOperation(operation)
    }

    func updateTodo(_ item: TodoItem, completion: @escaping (Result<Void, Error>) -> Void) {
        let operation = BlockOperation { [weak self] in
            guard let self = self else { return }

            let context = self.coreDataStack.newBackgroundContext()
            context.performAndWait {
                let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %lld", item.id)

                do {
                    let results = try context.fetch(fetchRequest)
                    if let entity = results.first {
                        entity.update(from: item)
                        try context.save()
                        DispatchQueue.main.async {
                            completion(.success(()))
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(.failure(StorageError.notFound))
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
        operationQueue.addOperation(operation)
    }

    func deleteTodo(id: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        let operation = BlockOperation { [weak self] in
            guard let self = self else { return }

            let context = self.coreDataStack.newBackgroundContext()
            context.performAndWait {
                let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %lld", id)

                do {
                    let results = try context.fetch(fetchRequest)
                    if let entity = results.first {
                        context.delete(entity)
                        try context.save()
                        DispatchQueue.main.async {
                            completion(.success(()))
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(.failure(StorageError.notFound))
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
        operationQueue.addOperation(operation)
    }

    func searchTodos(query: String, completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        let operation = BlockOperation { [weak self] in
            guard let self = self else { return }

            let context = self.coreDataStack.newBackgroundContext()
            context.performAndWait {
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
                    DispatchQueue.main.async {
                        completion(.success(items))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
        operationQueue.addOperation(operation)
    }

    func getNextId(completion: @escaping (Int64) -> Void) {
        let operation = BlockOperation { [weak self] in
            guard let self = self else { return }

            let context = self.coreDataStack.newBackgroundContext()
            context.performAndWait {
                let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
                fetchRequest.fetchLimit = 1

                do {
                    let results = try context.fetch(fetchRequest)
                    let nextId = (results.first?.id ?? 0) + 1
                    DispatchQueue.main.async {
                        completion(nextId)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(1)
                    }
                }
            }
        }
        operationQueue.addOperation(operation)
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
