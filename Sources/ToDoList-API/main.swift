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
    
    let routeKey = request.routeKey
    
    switch routeKey {
    
    case "GET /todoitems":
        let items = ToDoItem.getToDoList()
        let bodyOutput = try! JSONEncoder().encodeAsString(items)
        let output = Out(statusCode: .ok, headers: ["content-type": "application/json"], body: bodyOutput)
        callback(.success(output))
        
    case "GET /todoitems/{id}":
        if let idString = request.pathParameters?["id"], let id = Int(idString),
           let item = ToDoItem.getItem(with: id) {
            
            let bodyOutput = try! JSONEncoder().encodeAsString(item)
            let output = Out(statusCode: .ok, headers: ["content-type": "application/json"], body: bodyOutput)
            callback(.success(output))
        } else {
            callback(.success(Out(statusCode: .notFound)))
        }
        
    case "POST /todoitems":
        do {
            let input = try JSONDecoder().decode(ToDoItem.self, from: request.body ?? "")
            let bodyOutput = try JSONEncoder().encodeAsString(input)
            let output = Out(statusCode: .ok, headers: ["content-type": "application/json"], body: bodyOutput)
            callback(.success(output))
        } catch {
            callback(.success(Out(statusCode: .badRequest)))
        }
        
    default:
        callback(.success(Out(statusCode: .notFound)))
    }
}


