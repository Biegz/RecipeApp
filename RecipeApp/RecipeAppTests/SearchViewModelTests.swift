//
//  SearchViewModelTests.swift
//  RecipeAppTests
//
//  Created by Austin on 8/28/24.
//

import XCTest
@testable import RecipeApp

final class SearchViewModelTests: XCTestCase {
    var coreDataManager: CoreDataManager!
    var viewModel: SearchViewModel!

    override func setUpWithError() throws {
        coreDataManager = CoreDataManager(.inMemory)
        viewModel = SearchViewModel(
            networkManager: MockNetworkManager(),
            coreDataManager: coreDataManager
        )
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    func testRecipeTapped() {
        let expectedRecipeId = 0
        viewModel.recipeTapped(recipeId: expectedRecipeId)
        XCTAssertEqual(viewModel.selectedRecipeId, expectedRecipeId)
        XCTAssertTrue(viewModel.recipeInfoIsPresented)
    }
}
