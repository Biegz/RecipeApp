//
//  FavoritesViewModel.swift
//  RecipeApp
//
//  Created by Austin on 8/28/24.
//

import Foundation
import CoreData

class FavoritesViewModel: ObservableObject {
    let networkManager: NetworkManager
    @Published var favoriteRecipes: [RecipeEntity] = []
    @Published var recipeInfoIsPresented: Bool = false
    @Published var selectedRecipeId: Int?
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func onAppear() {
        fetchFavoriteRecipesFromLocalDataStore()
    }
    
    func recipeTapped(recipeId: Int64) {
        selectedRecipeId = Int(recipeId) 
        recipeInfoIsPresented = true
    }
    
    func confirmRecipeDeletion(recipeId: Int64) {
        deleteRecipeFromLocalDataStore(recipeId: recipeId)
    }
}

//  MARK: - Private
extension FavoritesViewModel {
    private func fetchFavoriteRecipesFromLocalDataStore() {
        let result = CoreDataManager.shared.fetchFavoriteRecipes()
        switch result {
            case .success(let recipes):
                favoriteRecipes = recipes
            case .failure(_):
                return  // TODO: Handle error
        }
    }
    
    private func deleteRecipeFromLocalDataStore(recipeId: Int64) {
        do {
            try CoreDataManager.shared.deleteRecipe(with: Int(recipeId))
            self.favoriteRecipes.removeAll(where: { $0.id == Int64(recipeId) })
        } catch {
            //  TODO: Handle error
        }
    }
}
