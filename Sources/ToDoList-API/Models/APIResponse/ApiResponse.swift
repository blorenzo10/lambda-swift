//
//  ApiResponse.swift
//  
//
//  Created by Bruno Lorenzo on 8/8/21.
//

import Foundation

struct ApiResponse: Encodable {
    
    typealias JSON = String
    
    let success: Bool
    var data: JSON?
    var error: String?
}
