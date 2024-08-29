//
//  ContentView.swift
//  RecipeApp
//
//  Created by Austin on 8/27/24.
//

import SwiftUI

fileprivate enum UIConstants {
    static let sidePadding: CGFloat = 12.0
}

struct SearchView: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Search for recipes", text: $viewModel.searchText)
                    .padding()
                    .background(Color.gray.opacity(0.25))
                    .cornerRadius(4.0)
                
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.recipes, id: \.id) { recipe in
                            SearchCard(
                                viewModel: viewModel.makeSearchCardViewModel(from: recipe)
                            )
                            .onTapGesture {
                                viewModel.recipeTapped(recipeId: recipe.id)
                            }
                            .onAppear {
                                if recipe.id == viewModel.recipes.last?.id {
                                    viewModel.bottomOfListAppeared()
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Search")
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
            .onChange(of: viewModel.searchText, { _, _ in
                viewModel.searchTermUpdated()
            })
            .padding(.horizontal, UIConstants.sidePadding)
        }
    }
}

#Preview {
    SearchView(
        viewModel: SearchViewModel(
            networkManager: MockNetworkManager(),
            coreDataManager: CoreDataManager(),
            searchText: "Pizz"
        )
    )
}
