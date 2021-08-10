//
//  Config.swift
//
//
//  Created by Bruno Lorenzo on 12/6/21.
//

import Foundation

class Config: NSObject {
    
    static let sharedInstance = Config()
    
    var config: NSDictionary?
    
    private override init() {
        
        guard let path = Bundle.module.path(forResource: "Config", ofType: "plist") else { return }
        config = NSDictionary(contentsOfFile: path)?.object(forKey: "Dev") as? NSDictionary
    }
    
}

extension Config {
    
    var dynamoDBKeyId: String {
        return config?.object(forKey: "DynamoDB-KeyId") as? String ?? ""
    }
    
    var dynamoDBAccessKey: String {
        return config?.object(forKey: "DynamoDB-KeyAccess") as? String ?? ""
    }
}
