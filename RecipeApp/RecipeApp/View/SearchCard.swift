//
//  SearchCard.swift
//  RecipeApp
//
//  Created by Austin on 8/29/24.
//

import SwiftUI

protocol SearchCardViewModelProtocol: AnyObject {
    func onFavoriteButtonTapped(_ recipe: Recipe)
}

class SearchCardViewModel: ObservableObject {
    let recipe: Recipe
    let recipeIsSaved: Bool
    weak var delegete: SearchCardViewModelProtocol?
    
    init(recipe: Recipe, recipeIsSaved: Bool) {
        self.recipe = recipe
        self.recipeIsSaved = recipeIsSaved
    }
    
    func favoriteButtonTapped() {
        delegete?.onFavoriteButtonTapped(recipe)
    }
}

struct SearchCard: View {
    @ObservedObject var viewModel: SearchCardViewModel
    
    var body: some View {
        ZStack {
            HStack {
                image
                Text(viewModel.recipe.title)
                Spacer()
                favoriteImage
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .background(.gray.opacity(0.1))
        .cornerRadius(4.0)
        .shadow(color: .gray.opacity(0.5), radius: 4.0)
    }
    
    private var image: some View {
        AsyncImage(url: viewModel.recipe.image) { img in
            img
                .resizable()
                .scaledToFill()
                .frame(width: 50)
                .clipShape(Circle())
        } placeholder: {
            Circle()
                .fill(.gray)
                .frame(width: 50)
        }
    }
    
    private var favoriteImage: some View {
        Image(systemName: viewModel.recipeIsSaved ? "star.fill" : "star")
            .resizable()
            .scaledToFit()
            .frame(width: 25)
            .onTapGesture {
                viewModel.favoriteButtonTapped()
            }
    }
}

#Preview {
    SearchCard(viewModel: SearchCardViewModel(recipe: .mockPizza, recipeIsSaved: true))
}
