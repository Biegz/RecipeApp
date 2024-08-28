//
//  RecipeViewModel.swift
//  RecipeApp
//
//  Created by Austin on 8/27/24.
//

import SwiftUI
import CoreData

class RecipeViewModel: ObservableObject {
    let networkManager: NetworkManager = NetworkManager(baseUrl: "https://api.spoonacular.com")
    let container: NSPersistentContainer
    
    @Published var recipeInfoIsPresented: Bool = false
    @Published var searchText: String = ""
    @Published var recipes: [Recipe] = []
    @Published var recipeInfo: RecipeInfoResponse?
    var currentOffset: Int = 0
    
    private var debounce_timer: Timer?
    @Published var favoriteRecipes: [RecipeEntity] = []
    
    private var shouldExecuteSearchRequest: Bool {
        searchText.count >= 1
    }
    
    init() {
        container = NSPersistentContainer(name: "RecipesContainer")
        container.loadPersistentStores { desc, error in
            if error != nil {
               //   TODO: Handle error
            }
        }
        fetchFavoriteRecipes()
    }
    
    func recipeTapped() {
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
                await self.performSearchRequest()
            }
        })
    }
    
    func onBottomOfListAppeared() {
        if !searchText.isEmpty {
            Task {
                await pageRecipes()
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

//  MARK: - Network Requests
extension RecipeViewModel {
    private func performSearchRequest() async {
        do {
            let endpoint = RecipesEndpoint.searchRecipe(query: searchText, offset: 0)
            let data = try await networkManager.fetchData(from: endpoint)
            let decodedResponse = try JSONDecoder().decode(RecipeSearchResponse.self, from: data)
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.currentOffset = decodedResponse.number
                self.recipes = decodedResponse.results
            }
        } catch {
            //  TODO: Handle error
        }
    }
    
    private func pageRecipes() async {
        do {
            let endpoint = RecipesEndpoint.searchRecipe(query: searchText, offset: currentOffset)
            let data = try await networkManager.fetchData(from: endpoint)
            let decodedResponse = try JSONDecoder().decode(RecipeSearchResponse.self, from: data)
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.currentOffset += decodedResponse.number
                self.recipes.append(contentsOf: decodedResponse.results)
            }
        } catch {
            //  TODO: Handle error
        }
    }
    
    func fetchRecipeInfo(with recipeId: Int) async {
        do {
            let data = try await networkManager.fetchData(from: RecipesEndpoint.fetchRecipeInfo(recipeId: recipeId))
            let decodedResponse = try JSONDecoder().decode(RecipeInfoResponse.self, from: data)
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.recipeInfo = decodedResponse
            }
        } catch {
            //  TODO: Handle error
        }
    }
}

//  MARK: - CoreData
extension RecipeViewModel {
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
