//
//  Routes.swift
//  
//
//  Created by Bruno Lorenzo on 8/8/21.
//

import Foundation
import AWSLambdaEvents

// POST /todoitem
// GET  /todoitem
// GET  /todoitem/:id

enum Routes {
    case signup
    case signin
    case todoitem
}

extension Routes: RouteInformation {
    var path: String {
        switch self {
        case .signup:
            return "/user"
        case .signin:
            return "/user/signin"
        case .todoitem:
            return "/todoitem"
        }
    }
}
