//
//  RouteInformation.swift
//  
//
//  Created by Bruno Lorenzo on 8/8/21.
//

import Foundation
import AWSLambdaEvents

protocol RouteInformation {
    var path: String { get }
}
