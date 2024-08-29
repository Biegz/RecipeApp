//
//  RecipeViewModel.swift
//  RecipeApp
//
//  Created by Austin on 8/27/24.
//

import SwiftUI
import CoreData

class SearchViewModel: ObservableObject {
    let networkManager: NetworkManager
    
    @Published var selectedRecipeId: Int?
    @Published var recipeInfoIsPresented: Bool = false
    @Published var searchText: String = ""
    @Published var recipes: [Recipe] = []
    @Published var favoriteRecipes: [RecipeEntity] = []
    var currentOffset: Int = 0
    private var debounce_timer: Timer?
    
    private var shouldExecuteSearchRequest: Bool {
        searchText.count >= 1
    }
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        fetchFavoriteRecipesFromLocalDataStore()
    }
    
    func recipeTapped(recipeId: Int) {
        selectedRecipeId = recipeId
        recipeInfoIsPresented = true
    }
    
    func recipeIsAlreadySaved(_ recipe: Recipe) -> Bool {
        favoriteRecipes.contains(where: { $0.id  == Int64(recipe.id)})
    }

    func searchTermUpdated() {
        guard shouldExecuteSearchRequest else { return }
        debounce_timer?.invalidate()
        debounce_timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            Task {
                let result = await self.networkManager.performSearchRequest(with: self.searchText)
                switch result {
                    case .success(let response):
                        DispatchQueue.main.async { [weak self] in
                            guard let self else { return }
                            self.currentOffset = response.number
                            self.recipes = response.results
                        }
                    case .failure(_):
                        return
                }
            }
        })
    }
    
    func bottomOfListAppeared() {
        guard !searchText.isEmpty else {
            return
        }
        Task {
            let result = await networkManager.performSearchRequest(with: searchText, offset: currentOffset)
            switch result {
                case .success(let response):
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        self.currentOffset += response.number
                        self.recipes.append(contentsOf: response.results)
                    }
                case .failure(_):
                    return
            }
            
        }
    }
    
    func favoriteButtonTapped(_ recipe: Recipe) {
        if recipeIsAlreadySaved(recipe) {
            deleteRecipeFromLocalDataStore(recipe: recipe)
        } else {
            saveRecipeToLocalDataStore(recipe: recipe)
        }
    }
}

//  MARK: - Private
extension SearchViewModel {
    private func fetchFavoriteRecipesFromLocalDataStore() {
        let result = CoreDataManager.shared.fetchFavoriteRecipes()
        switch result {
            case .success(let recipes):
                favoriteRecipes = recipes
            case .failure(_):
                return  // TODO: Handle error
        }
    }
    
    private func saveRecipeToLocalDataStore(recipe: Recipe) {
        Task {
            let result = await networkManager.fetchRecipeInfo(from: recipe.id)
            switch result {
                case .success(let recipeInfo):
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        do {
                            try CoreDataManager.shared.saveRecipe(with: recipe, recipeInfo: recipeInfo)
                        } catch {
                            //  TODO: Handle error
                        }
                        fetchFavoriteRecipesFromLocalDataStore()
                    }
                case .failure(_):
                    return
                    //  TODO: Handle error
            }
        }
    }
    
    private func deleteRecipeFromLocalDataStore(recipe: Recipe) {
        do {
            try CoreDataManager.shared.deleteRecipe(with: recipe.id)
            self.favoriteRecipes.removeAll(where: { $0.id == Int64(recipe.id) })
        } catch {
            //  TODO: Handle error
        }
    }
}
