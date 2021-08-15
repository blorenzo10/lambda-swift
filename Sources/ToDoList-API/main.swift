//
//  File.swift
//  
//
//  Created by Bruno Lorenzo on 8/8/21.
//

import Foundation
import AWSLambdaRuntime
import AWSLambdaEvents

typealias In = APIGateway.V2.Request
typealias Out = APIGateway.V2.Response


Lambda.run { (context,
              request: In,
              callback: @escaping (Result<Out, Error>) -> Void) in
    
    let path = request.context.http.path
    let method = request.context.http.method
    
    switch path {
    
    case "/todoitems":
        
        switch method {
        case .POST:
            do {
                let input = try JSONDecoder().decode(ToDoItem.self, from: request.body ?? "")
                let bodyOutput = try JSONEncoder().encodeAsString(input)
                let output = Out(statusCode: .ok, headers: ["content-type": "application/json"], body: bodyOutput)
                callback(.success(output))
            } catch {
                callback(.success(Out(statusCode: .badRequest)))
            }
            
        case .GET:
            if let idString = request.pathParameters?["id"], let id = Int(idString) {
                if let item = ToDoItem.getItem(with: id) {
                    let bodyOutput = try! JSONEncoder().encodeAsString(item)
                    let output = Out(statusCode: .ok, headers: ["content-type": "application/json"], body: bodyOutput)
                    callback(.success(output))
                } else {
                    callback(.success(Out(statusCode: .notFound)))
                }
            } else {
                let items = ToDoItem.getToDoList()
                let bodyOutput = try! JSONEncoder().encodeAsString(items)
                let output = Out(statusCode: .ok, headers: ["content-type": "application/json"], body: bodyOutput)
                callback(.success(output))
            }
            
        default:
            callback(.success(Out(statusCode: .notFound)))
        }
        
    default:
        callback(.success(Out(statusCode: .notFound)))
    }
}


