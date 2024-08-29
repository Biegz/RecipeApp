//
//  RecipeDetailViewModel.swift
//  RecipeApp
//
//  Created by Austin on 8/28/24.
//

import Foundation

class RecipeDetailViewModel: ObservableObject {
    let networkManager: NetworkManagerProtocol
    let coreDataManager: CoreDataManager
    let recipeId: Int
    @Published var recipeInfo: RecipeInfoResponse?
    
    init(networkManager: NetworkManagerProtocol, coreDataManager: CoreDataManager, recipeId: Int) {
        self.networkManager = networkManager
        self.coreDataManager = coreDataManager
        self.recipeId = recipeId
        getRecipeInfoFromLocalDataStore()
    }
    
    private func getRecipeInfoFromLocalDataStore() {
        do {
            let result = try coreDataManager.fetchRecipeInfo(with: recipeId)
            switch result {
                case .success(let recipeInfo):
                    self.recipeInfo = RecipeInfoResponse(
                        title: recipeInfo.title ?? "",
                        image: recipeInfo.image,
                        instructions: recipeInfo.instructions,
                        cookingMinutes: Int(recipeInfo.cookingMinutes),
                        extendedIngredients: nil
                    )
                case .failure(_):
                    getRecipeInfoViaNetwork()
            }
        } catch {
            getRecipeInfoViaNetwork()
        }
    }
    
    private func getRecipeInfoViaNetwork() {
        Task {
            let result = await networkManager.fetchRecipeInfo(from: recipeId)
            switch result {
                case .success(let recipeInfo):
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        self.recipeInfo = recipeInfo
                    }
                case .failure(_):
                    return
                    //  TODO: Handle error
            }
        }
    }
}
