//
//  RecipeDetailView.swift
//  RecipeApp
//
//  Created by Austin on 8/27/24.
//

import SwiftUI

struct RecipeDetailView: View {
    @ObservedObject var viewModel: RecipeDetailViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24.0) {
                HStack {
                    Text(viewModel.recipeInfo?.title ?? "")
                        .font(.headline)
                    Spacer()
                    image
                }
                if let ingredients = viewModel.recipeInfo?.extendedIngredients {
                    makeIngredientsList(with: ingredients)
                }
                if let instructions = viewModel.recipeInfo?.instructions {
                    makeInstructions(with: instructions)
                }
            }
            .padding()
        }
        .navigationTitle("Recipe Info")
    }
    
    private var image: some View {
        AsyncImage(url: URL(string: viewModel.recipeInfo?.image ?? "")) { img in
            img
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .clipShape(Circle())
        } placeholder: {
            Circle()
                .fill(.gray)
                .frame(width: 100)
        }
    }
    
    private func makeIngredientsList(with ingredients : [Ingredient]) -> some View {
        VStack(alignment: .leading) {
            Text("Ingredients")
                .font(.title2)
                .bold()
            ForEach(ingredients, id: \.name) { ingredient in
                Text("\(ingredient.amount) \(ingredient.unit) of \(ingredient.name)")
            }
        }

    }
    
    private func makeInstructions(with instructions: String) -> some View {
        VStack(alignment: .leading) {
            Text("Instructions")
                .font(.title2)
                .bold()
            Text(instructions)
        }
    }
}

#Preview {
    RecipeDetailView(
        viewModel: RecipeDetailViewModel(
            networkManager: MockNetworkManager(),
            coreDataManager: CoreDataManager(),
            recipeId: 0
        )
    )
}
