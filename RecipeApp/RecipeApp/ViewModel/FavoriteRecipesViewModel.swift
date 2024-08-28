//
//  FavoriteRecipesViewModel.swift
//  RecipeApp
//
//  Created by Austin on 8/28/24.
//

import Foundation
import CoreData

class FavoriteRecipesViewModel: ObservableObject {
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "RecipesContainer")
        container.loadPersistentStores { desc, error in
            if let error = error {
               //   TODO: Handle error
            }
        }
    }
}
