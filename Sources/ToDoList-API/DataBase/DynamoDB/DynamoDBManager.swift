//
//  DynamoDBManager.swift
//  
//
//  Created by Bruno Lorenzo on 8/8/21.
//

import Foundation
import SotoDynamoDB

final class DynamoDBManager {
    
    typealias DynamoDBAttributes = [String: DynamoDB.AttributeValue]
    private let database: DynamoDB
    
    init(database: DynamoDB) {
        self.database = database
    }
}

// MARK: - DBManager

extension DynamoDBManager: DBManager {
    
    func insert<T: Encodable>(in eventLoop: EventLoop, item: T, into table: String) -> EventLoopFuture<T> {
        
        if let data = encodeModel(item) {
            let input = DynamoDB.PutItemInput(item: data, tableName: table)
            return database.putItem(input).map { _ in
                item
            }
            
        } else {
            let fail: EventLoopFuture<T> = eventLoop.makeFailedFuture(ApiError.decodeError)
            return fail
        }
    }
    
    func query<T: Decodable>(byID id: String, from table: String) -> EventLoopFuture<T?> {
        let input = DynamoDB.GetItemInput(key: ["id": DynamoDB.AttributeValue.s(id)], tableName: table)
        
        return database.getItem(input, type: T.self).map { output in
            output.item
        }
    }
    
    func queryData<T: QueryModel>(_ model: T, from table: String) -> EventLoopFuture<T?>  {
        
        let identifierValue = createAttributeValue(from: model.identifierValue)
        
        let input = DynamoDB.QueryInput(
            expressionAttributeNames: ["#\(model.identifierName)" : model.identifierName],
            expressionAttributeValues: [":\(model.identifierName)": identifierValue],
            keyConditionExpression: "#\(model.identifierName) = :\(model.identifierName)",
            tableName: table
        )
        
        return database.query(input).map{ _ in model }
    }
    
    func queryAllItems<T: Decodable>(from table: String) -> EventLoopFuture<[T]> {
        let input = DynamoDB.ScanInput(tableName: table)
        return database.scan(input, type: T.self).map { output in
            output.items ?? []
        }
    }
}

// MARK: - Helpers

private extension DynamoDBManager {
    func encodeModel<T: Encodable>(_ model: T) -> [String : DynamoDB.AttributeValue]? {
        return try? DynamoDBEncoder().encode(model)
    }
    
    func createAttributeValue(from value: ValueType) -> DynamoDB.AttributeValue {
        switch value {
        case .number(let number):
            return DynamoDB.AttributeValue.n("\(number)")
            
        case .string(let string):
            return DynamoDB.AttributeValue.s(string)
        }
    }
}
