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

class NetworkManager {
    private let apiKey = "023b3a11d64f49bd8ac6f6f70f134d9a"
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
    
    private func fetchData(from endpoint: APIEndpoint) async throws -> Data {
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

extension NetworkManager {
    func fetchRecipeInfo(from recipeId: Int) async -> Result<RecipeInfoResponse, Error> {
            do {
                let data = try await fetchData(from: RecipesEndpoint.fetchRecipeInfo(recipeId: recipeId))
                let decodedResponse = try JSONDecoder().decode(RecipeInfoResponse.self, from: data)
                return .success(decodedResponse)
            } catch {
                return .failure(error)
            }
    }
    
    func performSearchRequest(with searchText: String, offset: Int = 0) async -> Result<RecipeSearchResponse, Error> {
        do {
            let endpoint = RecipesEndpoint.searchRecipe(query: searchText, offset: offset)
            let data = try await fetchData(from: endpoint)
            let decodedResponse = try JSONDecoder().decode(RecipeSearchResponse.self, from: data)
            return .success(decodedResponse)
        } catch {
            return .failure(error)
        }
    }
}
