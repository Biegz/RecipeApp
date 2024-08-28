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
                SearchView()
                    .environmentObject(RecipeViewModel())
                    .tabItem {
                        VStack {
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                        }
                    }
                
                FavoritesView()
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
