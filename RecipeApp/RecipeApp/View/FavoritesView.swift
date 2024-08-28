//
//  FavoritesView.swift
//  RecipeApp
//
//  Created by Austin on 8/27/24.
//

import SwiftUI
import CoreData

class FavoritesViewModel: ObservableObject {
    let container: NSPersistentContainer
    @Published var favoriteRecipes: [RecipeEntity] = []
    
    init() {
        container = NSPersistentContainer(name: "RecipesContainer")
        container.loadPersistentStores { desc, error in
            if error != nil {
               //   TODO: Handle error
            }
        }
        fetchFavoriteRecipes()
    }
    
    private func fetchFavoriteRecipes() {
        let reqeust = NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
        
        do {
            favoriteRecipes = try container.viewContext.fetch(reqeust)
        } catch {
            //  TODO: Handle error
        }
    }
}

struct FavoritesView: View {
    @ObservedObject var viewModel: FavoritesViewModel = FavoritesViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.favoriteRecipes, id: \.id) { recipe in
                if let title = recipe.title {
                    NavigationLink(title, value: recipe.id)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Favorites")
            .padding()
        }
    }
}

#Preview {
    FavoritesView(viewModel: FavoritesViewModel())
}
