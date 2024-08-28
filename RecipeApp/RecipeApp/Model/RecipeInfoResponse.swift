//
//  RecipeInfoResponse.swift
//  RecipeApp
//
//  Created by Austin on 8/27/24.
//

import Foundation

struct Ingredient: Decodable {
    let amount: Double
    let unit: String
    let name: String
}

struct RecipeInfoResponse: Decodable {
    let title: String
    let image: URL?
    let instructions: String?
    let cookingMinutes: Int?
    let extendedIngredients: [Ingredient]?
}
