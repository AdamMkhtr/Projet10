//
//  RecipeProviderProtocol.swift
//  Reciplease
//
//  Created by Adam Mokhtar on 04/07/2021.
//

import Foundation

protocol RecipeProviderProtocol {
  func fetchRecipes(
    querry: String,
    completion: @escaping ((Result<SearchResult, Error>) -> Void)
  )
}
