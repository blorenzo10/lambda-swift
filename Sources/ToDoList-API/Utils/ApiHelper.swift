//
//  File.swift
//
//
//  Created by Bruno Lorenzo on 17/5/21.
//

import Foundation
import AWSLambdaEvents

struct ApiHelper {
    
    typealias Headers = [String: String]
    
    private static let JSONHeader = ["Content-Type": "application/json"]
    
    static func makeErrorResponse(with error: ApiError) -> APIGateway.V2.Response {
        let apiResponse = ApiResponse(success: false, error: error.rawValue)
        return makeResponse(with: apiResponse)
    }
    
    static func makeSuccessReponse(with data: ApiResponse.JSON?) -> APIGateway.V2.Response {
        let apiResponse = ApiResponse(success: true, data: data)
        return makeResponse(with: apiResponse)
    }
    
}

// MARK: - Helpers

private extension ApiHelper {
    static func makeResponse(with apiResponse: ApiResponse) -> APIGateway.V2.Response {
        return APIGateway.V2.Response(
            statusCode: .ok,
            headers: JSONHeader,
            body: apiResponse.toJSON()
        )
    }
}
