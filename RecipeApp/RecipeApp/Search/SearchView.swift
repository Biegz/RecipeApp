//
//  ContentView.swift
//  RecipeApp
//
//  Created by Austin on 8/27/24.
//

import SwiftUI

class SearchViewModel: ObservableObject {
    
}

struct SearchView: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    SearchView(viewModel: SearchViewModel())
}
