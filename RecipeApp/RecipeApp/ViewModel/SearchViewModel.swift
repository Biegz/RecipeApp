//
//  RecipeViewModel.swift
//  RecipeApp
//
//  Created by Austin on 8/27/24.
//

import SwiftUI
import CoreData

class SearchViewModel: ObservableObject {
    let networkManager: NetworkManagerProtocol
    let coreDataManager: CoreDataManager
    
    @Published var recipeInfoIsPresented: Bool = false
    @Published var searchText: String = ""
    @Published private(set) var selectedRecipeId: Int?
    @Published private(set) var recipes: [Recipe] = []
    @Published private(set) var favoriteRecipes: [RecipeEntity] = []
    private(set) var currentOffset: Int = 0
    private(set) var debounce_timer: Timer?
    
    private var shouldExecuteSearchRequest: Bool {
        searchText.count >= 1
    }
    
    init(networkManager: NetworkManagerProtocol, coreDataManager: CoreDataManager) {
        self.networkManager = networkManager
        self.coreDataManager = coreDataManager
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
                let result = await self.networkManager.performSearchRequest(with: self.searchText, offset: 0)
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
        let result = coreDataManager.fetchFavoriteRecipes()
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
                            try coreDataManager.saveRecipe(with: recipe, recipeInfo: recipeInfo)
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
            try coreDataManager.deleteRecipe(with: recipe.id)
            self.favoriteRecipes.removeAll(where: { $0.id == Int64(recipe.id) })
        } catch {
            //  TODO: Handle error
        }
    }
}
