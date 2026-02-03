//
//  TodoEntity+CoreDataClass.swift
//  EmTest
//

import Foundation
import CoreData

@objc(TodoEntity)
public class TodoEntity: NSManagedObject {

    func toTodoItem() -> TodoItem {
        return TodoItem(
            id: self.id,
            title: self.title ?? "",
            description: self.todoDescription ?? "",
            createdAt: self.createdAt ?? Date(),
            isCompleted: self.isCompleted
        )
    }

    func update(from item: TodoItem) {
        self.id = item.id
        self.title = item.title
        self.todoDescription = item.description
        self.createdAt = item.createdAt
        self.isCompleted = item.isCompleted
    }
}
