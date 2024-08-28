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
    case invalidResponse
    case failedToRetrieveResponseData
}

class NetworkManager: ObservableObject {
    private let apiKey = "836a5bafc09748fe802927c306f7e3ac"
    let baseUrl: String
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    private func makeURLRequest(endpoint: APIEndpoint) throws -> URLRequest {
        guard var urlComponents = URLComponents(string: baseUrl + endpoint.path) else {
            throw NetworkError.failedToCreateURLComponents
        }
        urlComponents.queryItems = endpoint.qeuryItems
        urlComponents.queryItems?.append(contentsOf: [URLQueryItem(name: "apiKey", value: apiKey)]) 
        
        guard let url = urlComponents.url else {
            throw NetworkError.failedToCreateURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.rawValue
        return request
    }
    
    func fetchData(from endpoint: APIEndpoint) async throws -> Data {
        let urlRequest = try makeURLRequest(endpoint: endpoint)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard 
            let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode >= 200,
                httpResponse.statusCode < 300
        else {
            throw NetworkError.invalidResponse
        }
        
        return data
    }
}
