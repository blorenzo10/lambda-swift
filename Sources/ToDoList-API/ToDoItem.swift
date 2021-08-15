//
//  ToDoItem.swift
//  
//
//  Created by Bruno Lorenzo on 8/8/21.
//

import Foundation

struct ToDoItem: Codable {
    let id: Int
    let description: String
}

// MARK: - Static helpers

extension ToDoItem {
    static func getToDoList() -> [ToDoItem] {
        var list = [ToDoItem]()
        list.append(.init(id: 1, description: "Pay credit card"))
        list.append(.init(id: 2, description: "Clean apartment"))
        list.append(.init(id: 3, description: "Call John"))

        return list
    }

    static func getItem(with id: Int) -> ToDoItem? {
        return getToDoList().filter{ $0.id == id }.first
    }
}

