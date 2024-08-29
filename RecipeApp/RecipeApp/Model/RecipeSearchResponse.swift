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

extension RecipeSearchResponse {
    static let mock: RecipeSearchResponse = .init(number: 2, results: [.mockPizza, .mockPizzaBagel])
}

struct Recipe: Decodable {
    let id: Int
    let title: String
    let image: URL?
}

extension Recipe {
    static let mockPizza: Recipe = .init(id: 0, title: "Pizza", image: nil)
    static let mockPizzaBagel: Recipe = .init(id: 1, title: "Pizza Bagel", image: nil)
    static let mockBurger: Recipe = .init(id: 2, title: "Burger", image: nil)
}


