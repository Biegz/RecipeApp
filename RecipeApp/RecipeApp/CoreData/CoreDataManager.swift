//
//  CoreDataManager.swift
//  RecipeApp
//
//  Created by Austin on 8/28/24.
//

import Foundation
import CoreData

enum CoreDataError: Error {
    case unableToFindEntityToDelete
    case unableToFindEntity
}

class CoreDataManager {
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "RecipesContainer")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
    }
}

extension CoreDataManager {
    func fetchFavoriteRecipes() -> Result<[RecipeEntity], Error> {
        let reqeust = NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
        
        do {
            let results = try container.viewContext.fetch(reqeust)
            return .success(results)
        } catch {
            return .failure(error)
        }
    }
    
    func fetchRecipeInfo(with recipeId: Int) throws -> Result<RecipeInfoEntity, Error>{
        let fetchRequest: NSFetchRequest<RecipeEntity> = NSFetchRequest(entityName: "RecipeEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %d", recipeId)
        let results = try container.viewContext.fetch(fetchRequest)
        if let foundRecipe = results.first, let recipeInfo = foundRecipe.recipeInfo {
            return .success(recipeInfo)
        } else {
            throw CoreDataError.unableToFindEntity
        }
    }
    
    func saveRecipe(with recipe: Recipe, recipeInfo: RecipeInfoResponse) throws {
        let newRecipeInfoEntity = RecipeInfoEntity(context: container.viewContext)
        newRecipeInfoEntity.title = recipeInfo.title
        newRecipeInfoEntity.image = recipeInfo.image
        newRecipeInfoEntity.instructions = recipeInfo.instructions
        newRecipeInfoEntity.cookingMinutes = Int64(recipeInfo.cookingMinutes ?? 0)
        
        let newRecipeEntity = RecipeEntity(context: container.viewContext)
        newRecipeEntity.recipeInfo = newRecipeInfoEntity
        newRecipeEntity.id = Int64(recipe.id)
        newRecipeEntity.image = recipe.image?.absoluteString
        newRecipeEntity.title = recipe.title
        
        try container.viewContext.save()
    }
    
    func deleteRecipe(with recipeId: Int) throws {
        let fetchRequest: NSFetchRequest<RecipeEntity> = NSFetchRequest(entityName: "RecipeEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %d", recipeId)
        let results = try container.viewContext.fetch(fetchRequest)
        if let recipeToDelete = results.first {
            container.viewContext.delete(recipeToDelete)
            try container.viewContext.save()
        } else {
            throw CoreDataError.unableToFindEntityToDelete
        }
    }
}
