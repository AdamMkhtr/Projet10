//
//  RecipeConverter.swift
//  Reciplease
//
//  Created by Adam Mokhtar on 14/05/2021.
//

import Foundation
import UIKit

class RecipeConverter {
  
  //----------------------------------------------------------------------------
  // MARK: - Error Management
  //----------------------------------------------------------------------------
  
  enum RecipeConverterError: Error {
    case noResponse
  }
  
  //----------------------------------------------------------------------------
  // MARK: - Properties
  //----------------------------------------------------------------------------
  
  let recipeProvider: RecipeProviderProtocol
  private(set) var recipes = [Recipe]()
  
  init(recipeProvider: RecipeProviderProtocol = RecipeProvider()) {
    self.recipeProvider = recipeProvider
  }
  
  //----------------------------------------------------------------------------
  // MARK: - Methods
  //----------------------------------------------------------------------------
  
  /// Send the data on the API call to delegate
  /// - Parameter query: recup the list og ingredients for API call
  func convert(query: String, completion: @escaping ((Result<[Recipe], Error>) -> Void)) {
    recipeProvider.fetchRecipes(querry: query) { [weak self] result in
      switch result {
      case .success(let searchResult):
        guard let recipes = self?.convertFetchRecipesSuccess(searchResult: searchResult) else {
          completion(.failure(RecipeConverterError.noResponse))
          return
        }
        self?.recipes = recipes
        completion(.success(recipes))
        
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  /// this function is call when "convert" is success, use the delegate for send error at user,
  /// or for send the array of recipe
  /// - Parameter searchResult: collect the array of this class for work with
  private func convertFetchRecipesSuccess(searchResult: SearchResult) -> [Recipe]? {
    let recipes = searchResult.hits.map { $0.recipe }
    guard recipes.count > 0 else { return nil }
    return recipes
  }
  
}

