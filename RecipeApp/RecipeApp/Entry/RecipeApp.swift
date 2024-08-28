//
//  RecipeAppApp.swift
//  RecipeApp
//
//  Created by Austin on 8/27/24.
//

import SwiftUI

@main
struct RecipeApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                SearchView(viewModel: SearchViewModel())
                    .tabItem { Text("Search") }
                
                FavoritesView(viewModel: FavoritesViewModel())
                    .tabItem { Text("Favorites") }
            }
        }
    }
}
