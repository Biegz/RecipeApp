//
//  ContentView.swift
//  RecipeApp
//
//  Created by Austin on 8/27/24.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Search for recipes", text: $viewModel.searchText)
                    .padding()
                    .background(Color.gray.opacity(0.25))
                    .cornerRadius(4.0)
                
                List(viewModel.recipes, id: \.id) { recipe in
                    HStack {
                        Text(recipe.title)
                        Spacer()
                        makeFavoriteImage(from: recipe)
                    }
                    .onTapGesture {
                        viewModel.recipeTapped(recipeId: recipe.id)
                    }
                    .onAppear {
                        if recipe.id == viewModel.recipes.last?.id {
                            viewModel.bottomOfListAppeared()
                        }
                    }
                }
                .listStyle(.plain)

            }
            .navigationTitle("Search")
            .navigationDestination(isPresented: $viewModel.recipeInfoIsPresented, destination: {
                if let recipeId = viewModel.selectedRecipeId {
                    RecipeDetailView(
                        viewModel: RecipeDetailViewModel(
                            networkManager: viewModel.networkManager,
                            recipeId: recipeId
                        )
                    )
                }
            })
            .onChange(of: viewModel.searchText, { _, _ in
                viewModel.searchTermUpdated()
            })
            .padding()
        }
    }
    
    private func makeFavoriteImage(from recipe: Recipe) -> some View {
        Image(systemName: viewModel.recipeIsAlreadySaved(recipe) ? "star.fill" : "star")
            .resizable()
            .scaledToFit()
            .frame(width: 25)
            .onTapGesture {
                viewModel.favoriteButtonTapped(recipe)
            }
    }
}

#Preview {
    SearchView(
        viewModel: SearchViewModel(
            networkManager: NetworkManager(baseUrl: "")
        )
    )
}
