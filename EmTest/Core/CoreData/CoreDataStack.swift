//
//  CoreDataStack.swift
//  EmTest
//

import Foundation
import CoreData

final class CoreDataStack {

    static let shared = CoreDataStack()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let model = Self.createManagedObjectModel()
        let container = NSPersistentContainer(name: "EmTest", managedObjectModel: model)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func newBackgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    private static func createManagedObjectModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        let todoEntity = NSEntityDescription()
        todoEntity.name = "TodoEntity"
        todoEntity.managedObjectClassName = NSStringFromClass(TodoEntity.self)

        let idAttribute = NSAttributeDescription()
        idAttribute.name = "id"
        idAttribute.attributeType = .integer64AttributeType
        idAttribute.isOptional = false

        let titleAttribute = NSAttributeDescription()
        titleAttribute.name = "title"
        titleAttribute.attributeType = .stringAttributeType
        titleAttribute.isOptional = true

        let descriptionAttribute = NSAttributeDescription()
        descriptionAttribute.name = "todoDescription"
        descriptionAttribute.attributeType = .stringAttributeType
        descriptionAttribute.isOptional = true

        let createdAtAttribute = NSAttributeDescription()
        createdAtAttribute.name = "createdAt"
        createdAtAttribute.attributeType = .dateAttributeType
        createdAtAttribute.isOptional = true

        let isCompletedAttribute = NSAttributeDescription()
        isCompletedAttribute.name = "isCompleted"
        isCompletedAttribute.attributeType = .booleanAttributeType
        isCompletedAttribute.isOptional = false
        isCompletedAttribute.defaultValue = false

        todoEntity.properties = [idAttribute, titleAttribute, descriptionAttribute, createdAtAttribute, isCompletedAttribute]

        model.entities = [todoEntity]

        return model
    }
}
