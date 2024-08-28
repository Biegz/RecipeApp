//
//  RecipesEndpoint.swift
//  RecipeApp
//
//  Created by Austin on 8/27/24.
//

import Foundation

enum RecipesEndpoint: APIEndpoint {
    case searchRecipe(query: String, offset: Int)
    case fetchRecipeInfo(recipeId: Int)
    
    var path: String {
        switch self {
            case .searchRecipe(let query, let offset):
                "/recipes/complexSearch?query=\(query)&offset=\(offset)"
            case .fetchRecipeInfo(let recipeId):
                "/recipes/\(recipeId)/information"
        }
    }
    
    var qeuryItems: [URLQueryItem] {
        var items: [URLQueryItem] = []
        switch self {
            case .searchRecipe(let query, let offset):
                items.append(URLQueryItem(name: "query", value: query))
                items.append(URLQueryItem(name: "offset", value: "\(offset)"))
            default:
                return items
        }
        return items
    }
    
    var httpMethod: HTTPMethod {
        switch self {
            case .searchRecipe, .fetchRecipeInfo:
                .get
        }
    }
}
