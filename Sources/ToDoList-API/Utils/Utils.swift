//
//  Utils.swift
//  
//
//  Created by Bruno Lorenzo on 8/8/21.
//

import Foundation

struct Utils {
    
    static func decodeJSON<T: Decodable>(from body: String?) -> T? {
        guard let body = body else { return nil }
        let bodyData = Data(body.utf8)
        let request = try? JSONDecoder().decode(T.self, from: bodyData)
        return request
    }
}

