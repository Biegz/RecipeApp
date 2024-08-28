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
    let container: NSPersistentContainer
    
    @Published var selectedRecipeId: Int?
    @Published var recipeInfoIsPresented: Bool = false
    @Published var searchText: String = ""
    @Published var recipes: [Recipe] = []
    var currentOffset: Int = 0
    
    private var debounce_timer: Timer?
    @Published var favoriteRecipes: [RecipeEntity] = []
    
    private var shouldExecuteSearchRequest: Bool {
        searchText.count >= 1
    }
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        container = NSPersistentContainer(name: "RecipesContainer")
        container.loadPersistentStores { desc, error in
            if error != nil {
               //   TODO: Handle error
            }
        }
        fetchFavoriteRecipes()
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
    
    func onBottomOfListAppeared() {
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
    
    func onFavoriteButtonTapped(_ recipe: Recipe) {
        if recipeIsAlreadySaved(recipe) {
            deleteRecipe(with: recipe)
        } else {
            saveRecipe(with: recipe)
        }
    }
}

//  MARK: - CoreData
extension SearchViewModel {
    private func fetchFavoriteRecipes() {
        let reqeust = NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
        
        do {
            favoriteRecipes = try container.viewContext.fetch(reqeust)
        } catch {
            //  TODO: Handle error
        }
    }
    
    private func saveRecipe(with recipe: Recipe) {
        let newRecipeEntity = RecipeEntity(context: container.viewContext)
        newRecipeEntity.id = Int64(recipe.id)
        newRecipeEntity.image = recipe.image?.absoluteString
        newRecipeEntity.title = recipe.title
        do {
            try container.viewContext.save()
            fetchFavoriteRecipes()
        } catch {
            print("here")
            //  TODO: Handle error
        }
    }
    
    private func deleteRecipe(with recipe: Recipe) {
        let fetchRequest: NSFetchRequest<RecipeEntity> = NSFetchRequest(entityName: "RecipeEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %d", recipe.id)
        
        do {
            let results = try container.viewContext.fetch(fetchRequest)
            if let recipeToDelete = results.first {
                container.viewContext.delete(recipeToDelete)
                try container.viewContext.save()
                self.favoriteRecipes.removeAll(where: { $0.id == Int64(recipe.id) })
            }
        } catch {
            print("here")
            // TODO: Handle error
        }
    }
}
