//
//  FavoritesView.swift
//  RecipeApp
//
//  Created by Austin on 8/27/24.
//

import SwiftUI

class FavoritesViewModel: ObservableObject {
    
}

struct FavoritesView: View {
    @ObservedObject var viewModel: FavoritesViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    FavoritesView(viewModel: FavoritesViewModel())
}
