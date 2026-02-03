//
//  TodoEntity+CoreDataProperties.swift
//  EmTest
//

import Foundation
import CoreData

extension TodoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoEntity> {
        return NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var todoDescription: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var isCompleted: Bool
}

extension TodoEntity: Identifiable {}
