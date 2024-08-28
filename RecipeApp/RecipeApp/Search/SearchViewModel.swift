//
//  SearchViewModel.swift
//  RecipeApp
//
//  Created by Austin on 8/27/24.
//

import Foundation

class SearchViewModel: ObservableObject {
    private let networkManager: NetworkManager
    @Published var searchText: String = ""
    @Published var recipes: [Recipe] = []
    private var debounce_timer: Timer?
    
    var shouldExecuteSearchRequest: Bool {
        searchText.count >= 1
    }
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func searchTermUpdated() {
        guard shouldExecuteSearchRequest else { return }
        debounce_timer?.invalidate()
        debounce_timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            Task {
                await self.performSearchRequest()
            }
        })
    }

    func performSearchRequest() async {
        do {
            let endpoint = RecipesEndpoint.searchRecipe(query: searchText)
            let (data, _) = try await URLSession.shared.data(
                for: networkManager.makeURLRequest(endpoint: endpoint)
            )
            let decodedResponse = try JSONDecoder().decode(RecipeSearchResponse.self, from: data)
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.recipes = decodedResponse.results
            }
        } catch {
            //  TODO: Catch error
        }
    }
}
