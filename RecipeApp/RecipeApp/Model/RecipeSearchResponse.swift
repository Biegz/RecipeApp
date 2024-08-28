//
//  RecipeSearchResponse.swift
//  RecipeApp
//
//  Created by Austin on 8/27/24.
//

import Foundation

struct RecipeSearchResponse: Decodable {
    let number: Int
    let results: [Recipe]
}

struct Recipe: Decodable {
    let id: Int
    let title: String
    let image: URL?
}
