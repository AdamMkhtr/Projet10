//
//  RecipleaseTests.swift
//  RecipleaseTests
//
//  Created by Adam Mokhtar on 05/05/2021.
//

import XCTest
@testable import Reciplease

class RecipeProviderMockTestConvert: RecipeProviderProtocol {

  func fetchRecipes(
    querry: String,
    completion: @escaping ((Result<SearchResult, Error>) -> Void)
  ) {
    let recipe = Recipe(label: "test",
                        image: "",
                        url: "",
                        shareAs: "",
                        dietLabels: [""],
                        healthLabels: [""],
                        cautions: [""],
                        ingredientLines: [""])

    let hit = Hit(recipe: recipe)

    let result = SearchResult(q: "",
                              from: 0,
                              to: 1,
                              more: true,
                              count: 1,
                              hits: [hit])

    return completion(.success(result))
  }
}

class RecipeConverterTest: XCTestCase {

  var recipeResults: [Recipe]?
  var expectation: XCTestExpectation?

  func test_convert() {
    let converter = RecipeConverter(recipeProvider: RecipeProviderMockTestConvert())

    expectation = expectation(description: "Convert")

    converter.convert(query: "test") { [self] result in
      switch result {

      case .success(_):
        try? recipeResults = result.get()

      case .failure(_): break
      }

      expectation?.fulfill()
    }
    wait(for: [expectation!], timeout: 0.1)
    XCTAssertNotNil(recipeResults)
    XCTAssertEqual("test", recipeResults?.first?.label)
  }

}

