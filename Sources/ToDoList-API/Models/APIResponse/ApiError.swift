//
//  File.swift
//  
//
//  Created by Bruno Lorenzo on 8/8/21.
//

import Foundation

enum ApiError: String, Error, Encodable {
    
    // MARK: - Generic errors
    
    case decodeError = "Could not decode model"
    case insertError = "Could not insert model into database"
    case serverError = "Unexpected error"
    case duplicateKey = "A record with the key already exists"
    
    // MARK: - Login errors
    
    case userAlreadyExists = "The email is already taken"
    case invalidCredentials = "The email or password are not correct"
}
