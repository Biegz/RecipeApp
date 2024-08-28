//
//  RecipeDetailView.swift
//  RecipeApp
//
//  Created by Austin on 8/27/24.
//

import SwiftUI

class RecipeDetailViewModel: ObservableObject {
    let recipeId: Int
    
    init(recipeId: Int) {
        self.recipeId = recipeId
    }
}

struct RecipeDetailView: View {
    @ObservedObject var viewModel: RecipeDetailViewModel
    
    var body: some View {
        Text("Recipe ID: \(viewModel.recipeId)")
    }
}

#Preview {
    RecipeDetailView(viewModel: RecipeDetailViewModel(recipeId: 0))
}
