//
//  ToDoItem.swift
//  
//
//  Created by Bruno Lorenzo on 8/8/21.
//

import Foundation

struct ToDoItem: Codable {
    var id: UUID?
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case description
    }
}
