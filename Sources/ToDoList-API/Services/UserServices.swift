//
//  File.swift
//  
//
//  Created by Bruno Lorenzo on 8/8/21.
//

import Foundation
import NIO
import AWSLambdaRuntime
import AWSLambdaEvents

extension LambdaHandler {
    
    func signup(_ context: Lambda.Context, _ event: In) -> EventLoopFuture<Out> {
        
        guard let apiRequest: SignupRequest = Utils.decodeJSON(from: event.body) else {
            return context.eventLoop.makeSucceededFuture(
                Out(statusCode: .badRequest)
            )
        }
        
        let promise = context.eventLoop.makePromise(of: Out.self)
        let scanQuery = dbManager.queryData(apiRequest, from: Tables.users)
        
        scanQuery.whenSuccess { request in
            if request == nil {
                let user = User(email: apiRequest.email, name: apiRequest.name)
                let insertQuery = dbManager.insert(in: context.eventLoop, item: user, into: Tables.users)
                
                insertQuery.whenSuccess { user in
                    let out = ApiHelper.makeSuccessReponse(with: user.toJSON())
                    promise.succeed(out)
                }
                
                insertQuery.whenFailure { error in
                    promise.fail(error)
                }
            } else {
                promise.fail(ApiError.userAlreadyExists)
            }
        }
        
        scanQuery.whenFailure { error in
            promise.fail(error)
        }
        
        return promise.futureResult
    }
}
