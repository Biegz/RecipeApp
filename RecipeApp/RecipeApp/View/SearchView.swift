//
//  ContentView.swift
//  RecipeApp
//
//  Created by Austin on 8/27/24.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var viewModel: RecipeViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Search for recipes", text: $viewModel.searchText)
                    .padding()
                    .background(Color.gray.opacity(0.25))
                    .cornerRadius(4.0)
                
                List(viewModel.recipes, id: \.id) { recipe in
                    NavigationLink(value: recipe.id) {
                        HStack {
                            Text(recipe.title)
                            Spacer()
                            makeFavoriteImage(from: recipe)
                        }
                    }
                        .onAppear {
                            if recipe.id == viewModel.recipes.last?.id {
                                viewModel.onBottomOfListAppeared()
                            }
                        }
                }
                .listStyle(.plain)

            }
            .navigationTitle("Search")
            .navigationDestination(for: Int.self) { recipeId in
                RecipeDetailView(recipeId: recipeId)
                    .environmentObject(viewModel)
            }
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
                viewModel.onFavoriteButtonTapped(recipe)
            }
    }
}

#Preview {
    SearchView()
}
