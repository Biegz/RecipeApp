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
                    NavigationLink(destination: RecipeDetailView(
                        viewModel: RecipeDetailViewModel(recipeId: recipe.id)
                    )) {
                        Text(recipe.title)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Search")
            .onChange(of: viewModel.searchText, { _, _ in
                viewModel.searchTermUpdated()
            })
            .padding()
        }
    }
}

#Preview {
    SearchView(viewModel: SearchViewModel(networkManager: NetworkManager(baseUrl: "")))
}
