//
//  RecipeProviderTest.swift
//  RecipleaseTests
//
//  Created by Adam Mokhtar on 04/07/2021.
//

import XCTest

class RecipeProviderMock: RecipeProviderProtocol {

  func fetchRecipes(
    querry: String,
    completion: @escaping ((Result<SearchResult, Error>) -> Void)
  ) {
    let result = SearchResult(q: "",
                              from: 0,
                              to: 1,
                              more: true,
                              count: 1,
                              hits: [])
    return completion(.success(result))
  }
}

class RecipeProviderTest: XCTestCase {

  func testFetchRecipes() throws {
    let mock = RecipeProviderMock()

    let expectation = self.expectation(description: "Fetching")

    mock.fetchRecipes(querry: "") { result in
      let searchResult = try? result.get()
      
      expectation.fulfill()

      XCTAssertNotNil(searchResult)
    }
    waitForExpectations(timeout: 5, handler: nil)
  }
}
