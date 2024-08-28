//
//  NetworkManager.swift
//  RecipeApp
//
//  Created by Austin on 8/27/24.
//

import Foundation

enum NetworkError: Error {
    case failedToCreateURLComponents
    case failedToCreateURL
}

class NetworkManager {
    private let apiKey = "dba33a7a8bb54fc4a81388625efeb06c"
    let baseUrl: String
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    func makeURLRequest(endpoint: APIEndpoint) throws -> URLRequest {
        guard var urlComponents = URLComponents(string: baseUrl + endpoint.path) else {
            throw NetworkError.failedToCreateURLComponents
        }
        urlComponents.queryItems = [URLQueryItem(name: "apiKey", value: apiKey)]
        
        guard let url = urlComponents.url else {
            throw NetworkError.failedToCreateURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.rawValue
        return request
    }
}
