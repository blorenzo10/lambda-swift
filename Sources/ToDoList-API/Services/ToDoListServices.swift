//
//  File.swift
//  
//
//  Created by Bruno Lorenzo on 9/8/21.
//

import Foundation
import NIO
import AWSLambdaRuntime
import AWSLambdaEvents

extension LambdaHandler {
    
    func createNewItem(_ context: Lambda.Context, _ event: In) -> EventLoopFuture<Out> {
        guard let apiRequest: ToDoItem = Utils.decodeJSON(from: event.body) else {
            return context.eventLoop.makeSucceededFuture(
                Out(statusCode: .badRequest)
            )
        }
        
        let promise = context.eventLoop.makePromise(of: Out.self)
        
        let toDoItem = ToDoItem(id: UUID(), description: apiRequest.description)
        let insertQuery = dbManager.insert(in: context.eventLoop, item: toDoItem, into: Tables.toDoItems)
        insertQuery.whenSuccess { item in
            let out = ApiHelper.makeSuccessReponse(with: item.toJSON())
            promise.succeed(out)
        }
        
        insertQuery.whenFailure { error in
            promise.fail(error)
        }
        
        return promise.futureResult
    }
    
    func retrieveItem(_ id: String, _ context: Lambda.Context, _ event: In) -> EventLoopFuture<Out> {
        
        let promise = context.eventLoop.makePromise(of: Out.self)
        
        let scanQuery: EventLoopFuture<ToDoItem?> = dbManager.query(byID: id, from: Tables.toDoItems)
        scanQuery.whenSuccess { item in
            let out = ApiHelper.makeSuccessReponse(with: item.toJSON())
            promise.succeed(out)
        }
        
        scanQuery.whenFailure { error in
            promise.fail(error)
        }
        
        return promise.futureResult
    }
    
    func retrieveAllItems(_ context: Lambda.Context) -> EventLoopFuture<Out> {
        let promise = context.eventLoop.makePromise(of: Out.self)
        
        let scanQuery: EventLoopFuture<[ToDoItem]> = dbManager.queryAllItems(from: Tables.toDoItems)
        scanQuery.whenSuccess { toDoItemList in
            let out = ApiHelper.makeSuccessReponse(with: toDoItemList.toJSON())
            promise.succeed(out)
        }
        
        scanQuery.whenFailure { error in
            promise.fail(error)
        }
        
        return promise.futureResult
    }
}
