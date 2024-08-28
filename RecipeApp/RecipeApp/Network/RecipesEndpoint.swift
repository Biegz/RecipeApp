//
//  RecipesEndpoint.swift
//  RecipeApp
//
//  Created by Austin on 8/27/24.
//

import Foundation

enum RecipesEndpoint: APIEndpoint {
    case searchRecipe(query: String)
    
    var path: String {
        switch self {
            case .searchRecipe(let query):
                "/recipes/complexSearch?query=\(query)"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
            case .searchRecipe:
                .get
        }
    }
}
