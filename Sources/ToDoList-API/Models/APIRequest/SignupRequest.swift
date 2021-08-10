//
//  SignupRequest.swift
//  
//
//  Created by Bruno Lorenzo on 8/8/21.
//

import Foundation

struct SignupRequest: Decodable {
    let email: String
    let name: String
    let password: String
}

extension SignupRequest: QueryModel {
    
    var identifierName: String {
        "email"
    }
    
    var identifierValue: ValueType {
        .string(email)
    }
}
