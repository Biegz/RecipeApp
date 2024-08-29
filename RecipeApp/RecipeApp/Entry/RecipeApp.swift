//
//  RecipeAppApp.swift
//  RecipeApp
//
//  Created by Austin on 8/27/24.
//

import SwiftUI

@main
struct RecipeApp: App {
    //  Live Services
    let coreDataManager: CoreDataManager = CoreDataManager()
    let networkManager: NetworkManagerProtocol = NetworkManager(baseUrl: "https://api.spoonacular.com")
    
    //  Mock Services
    //let networkManager: NetworkManagerProtocol = MockNetworkManager()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                SearchView(
                    viewModel: SearchViewModel(
                        networkManager: networkManager,
                        coreDataManager: coreDataManager
                    )
                )
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                
                FavoritesView(
                    viewModel: FavoritesViewModel(
                        networkManager: networkManager,
                        coreDataManager: coreDataManager
                    )
                )
                .tabItem {
                    Image(systemName: "star")
                    Text("Favorites")
                }
            }
        }
    }
}

#Preview {
    TabView {
        SearchView(
            viewModel: SearchViewModel(
                networkManager: MockNetworkManager(),
                coreDataManager: CoreDataManager()
            )
        )
        .tabItem {
            Image(systemName: "magnifyingglass")
            Text("Search")
        }
        
        FavoritesView(
            viewModel: FavoritesViewModel(
                networkManager: MockNetworkManager(),
                coreDataManager: CoreDataManager()
            )
        )
        .tabItem {
            Image(systemName: "star")
            Text("Favorites")
        }
    }
}
