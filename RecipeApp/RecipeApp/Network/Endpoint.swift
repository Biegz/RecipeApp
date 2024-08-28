//
//  Endpoint.swift
//  RecipeApp
//
//  Created by Austin on 8/27/24.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol APIEndpoint {
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var qeuryItems: [URLQueryItem] { get }
}
