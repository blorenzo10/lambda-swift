//
//  DBManager.swift
//  
//
//  Created by Bruno Lorenzo on 8/8/21.
//

import Foundation
import NIO

protocol DBManager {
    func insert<T: Encodable>(in eventLoop: EventLoop, item: T, into table: String) -> EventLoopFuture<T>
    func query<T: Decodable>(byID id: String, from table: String) -> EventLoopFuture<T?>
    func queryData<T: QueryModel>(_ model: T, from table: String) -> EventLoopFuture<T?>
    func queryAllItems<T: Decodable>(from table: String) -> EventLoopFuture<[T]>
}

enum ValueType {
    case number(_ value: Int)
    case string(_ value: String)
}

protocol QueryModel {
    
    var identifierName: String { get }
    var identifierValue: ValueType { get }
}
