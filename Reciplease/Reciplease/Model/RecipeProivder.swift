//
//  RecipeProivder.swift
//  Reciplease
//
//  Created by Adam Mokhtar on 10/05/2021.
//

import Foundation
import Alamofire


class RecipeProvider: RecipeProviderProtocol {
  
  //----------------------------------------------------------------------------
  // MARK: - Error Management
  //----------------------------------------------------------------------------

  enum RecipeProviderError: LocalizedError {
    case errorResponse
    
    var errorDescription: String? {
      switch self {
      case .errorResponse: return "error response"
      }
    }
  }
  
  //----------------------------------------------------------------------------
  // MARK: - Properties
  //----------------------------------------------------------------------------
  
  private var url = "https://api.edamam.com/search"

  private let apiKey: String

  init(apiKey: String = APIKeys.keyAPIEdamam) {
    self.apiKey = apiKey
  }


  //----------------------------------------------------------------------------
  // MARK: - Methods
  //----------------------------------------------------------------------------
  
  /// Call the API edaman for collect data
  /// - Parameters:
  ///   - querry: ingredients for API call
  ///   - completion: completion return an array with recipes
  func fetchRecipes(
    querry: String,
    completion: @escaping ((Result<SearchResult, Error>) -> Void)
  ) {
    var queryParameters: [String: Any] = [
      "app_id": "2e3b92d4",
      "app_key": apiKey,
      "from": 0,
      "to": 10
    ]
    queryParameters["q"] = querry
    
    let request = AF.request(url, parameters: queryParameters)
    
    request.responseJSON { (response) in
      guard let data = response.data else {
        completion(.failure(RecipeProviderError.errorResponse))
        return
      }

      do {
        let welcome = try JSONDecoder().decode(SearchResult.self, from: data)
        completion(.success(welcome))
      } catch {
        print(error.localizedDescription)
        completion(.failure(error))
      }
    }
  }

}
