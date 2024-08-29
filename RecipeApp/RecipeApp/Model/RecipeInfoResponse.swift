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
    let image: String?
    let instructions: String?
    let cookingMinutes: Int?
    let extendedIngredients: [Ingredient]?
}

extension RecipeInfoResponse {
    static let mockBurgerRecipe: RecipeInfoResponse = .init(
        title: "Burger",
        image: nil,
        instructions: "Cook burger on cast iron. Flip halfway through cooking time",
        cookingMinutes: 10,
        extendedIngredients: nil
    )
    
    static let mockPizzaRecipe: RecipeInfoResponse = .init(
        title: "Pizza",
        image: nil,
        instructions: "Make dough from scratch. Top with cheese and sauce and throw in the oven",
        cookingMinutes: 10,
        extendedIngredients: nil
    )
    
    static let mockPizzaBagelRecipe: RecipeInfoResponse = .init(
        title: "Pizza Bagel",
        image: nil,
        instructions: "Put mozz and sauce on a plain bagel and throw it in the oven",
        cookingMinutes: 10,
        extendedIngredients: nil
    )
}
