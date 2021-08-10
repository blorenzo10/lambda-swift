//
//  File.swift
//  
//
//  Created by Bruno Lorenzo on 8/8/21.
//

import Foundation

extension Encodable {
    func toJSON() -> String? {
        let jsonEncoder = JSONEncoder()
        return try? jsonEncoder.encodeAsString(self)
    }
}
