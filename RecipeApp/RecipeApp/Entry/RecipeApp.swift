//
//  RecipeAppApp.swift
//  RecipeApp
//
//  Created by Austin on 8/27/24.
//

import SwiftUI

@main
struct RecipeApp: App {
    let networkManager: NetworkManager = NetworkManager(baseUrl: "https://api.spoonacular.com")
    
    var body: some Scene {
        WindowGroup {
            TabView {
                SearchView(
                    viewModel: SearchViewModel(networkManager: networkManager)
                )
                    .tabItem {
                        VStack {
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                        }
                    }
                
                FavoritesView(
                    viewModel: FavoritesViewModel(networkManager: networkManager)
                )
                    .tabItem {
                        VStack {
                            Image(systemName: "star")
                            Text("Favorites")
                        }
                    }
            }
        }
    }
}
