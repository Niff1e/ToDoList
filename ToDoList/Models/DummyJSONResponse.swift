//
//  DummyJSONResponse.swift
//  ToDoList
//
//  Created by Pavel Maal on 21.11.24.
//

import Foundation

struct DummyJSONResponse: Codable {
    let todos: [ToDoItem]
    let total: Int
    let skip: Int
    let limit: Int
}

struct ToDoItem: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}
