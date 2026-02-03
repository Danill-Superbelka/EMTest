//
//  TodoItem.swift
//  EmTest
//

import Foundation

struct TodoItem: Equatable {
    let id: Int64
    var title: String
    var description: String
    var createdAt: Date
    var isCompleted: Bool

    init(id: Int64, title: String, description: String = "", createdAt: Date = Date(), isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.description = description
        self.createdAt = createdAt
        self.isCompleted = isCompleted
    }
}

struct TodoAPIResponse: Codable {
    let todos: [TodoAPIItem]
    let total: Int
    let skip: Int
    let limit: Int
}

struct TodoAPIItem: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}
