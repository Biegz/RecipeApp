//
//  FavoritesView.swift
//  RecipeApp
//
//  Created by Austin on 8/27/24.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: FavoritesViewModel
    
    var body: some View {
        NavigationStack {
            List(viewModel.favoriteRecipes, id: \.id) { recipe in
                if let title = recipe.title {
                    Text(title)
                        .onTapGesture {
                            viewModel.recipeTapped(recipeId: recipe.id)
                        }
                        .swipeActions {
                            Button("Delete", role: .destructive) {
                                viewModel.confirmRecipeDeletion(recipeId: recipe.id)
                            }
                        }
                }

            }
            .listStyle(.plain)
            .navigationTitle("Favorites")
            .onAppear {
                viewModel.onAppear()
            }
            .navigationDestination(isPresented: $viewModel.recipeInfoIsPresented, destination: {
                if let recipeId = viewModel.selectedRecipeId {
                    RecipeDetailView(
                        viewModel: RecipeDetailViewModel(
                            networkManager: viewModel.networkManager,
                            coreDataManager: viewModel.coreDataManager,
                            recipeId: recipeId
                        )
                    )
                }
            })
            .padding()
        }
    }
}

#Preview {
    FavoritesView(
        viewModel: FavoritesViewModel(
            networkManager: MockNetworkManager(),
            coreDataManager: CoreDataManager()
        )
    )
}
