//
//  File.swift
//  
//
//  Created by Bruno Lorenzo on 8/8/21.
//

import Foundation
import AWSLambdaRuntime
import AWSLambdaEvents
import NIO
import SotoCore
import SotoDynamoDB

struct LambdaHandler: EventLoopLambdaHandler {
    typealias In = APIGateway.V2.Request
    typealias Out = APIGateway.V2.Response
    
    let dbManager: DBManager
    
    init(context: Lambda.InitializationContext) {
        
        let awsclient = AWSClient(
            credentialProvider: .static(
                accessKeyId: Config.sharedInstance.dynamoDBKeyId,
                secretAccessKey: Config.sharedInstance.dynamoDBAccessKey
            ),
            retryPolicy: .noRetry,
            httpClientProvider: .createNewWithEventLoopGroup(context.eventLoop)
        )
        
        let dynamoDB = DynamoDB(client: awsclient)
        self.dbManager = DynamoDBManager(database: dynamoDB)
    }
    
    
    func handle(context: Lambda.Context, event: In) -> EventLoopFuture<Out> {
        
        let path = event.context.http.path
        let method = event.context.http.method
        
        switch path {

        case Routes.signup.path:
            
            switch method {
            case .POST:
                return signup(context, event)
                
            default:
                return context.eventLoop.makeSucceededFuture(Out(statusCode: .notFound))
            }
            
            
        case Routes.todoitem.path:
            
            switch event.context.http.method {
            
            case .GET:
                if let id = event.pathParameters?["id"] {
                    return retrieveItem(id, context, event)
                } else {
                    return retrieveAllItems(context)
                }
                
            case .POST:
                return createNewItem(context, event)
                
            default:
                return context.eventLoop.makeSucceededFuture(Out(statusCode: .notFound))
            }
            
        default:
            return context.eventLoop.makeSucceededFuture(Out(statusCode: .notFound))
        }
    }
}

Lambda.run(LambdaHandler.init)

//Lambda.run { (context, request: APIGateway.V2.Request, callback: @escaping (Result<APIGateway.V2.Response, Error>) -> Void) in
//    callback(.success(APIGateway.V2.Response(statusCode: .ok)))
//}
