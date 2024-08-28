//
//  RecipeDetailViewModel.swift
//  RecipeApp
//
//  Created by Austin on 8/28/24.
//

import Foundation

class RecipeDetailViewModel: ObservableObject {
    let networkManager: NetworkManager
    let recipeId: Int
    @Published var recipeInfo: RecipeInfoResponse?
    
    init(networkManager: NetworkManager, recipeId: Int) {
        self.networkManager = networkManager
        self.recipeId = recipeId
        getRecipeInfo()
    }
    
    private func getRecipeInfo() {
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
