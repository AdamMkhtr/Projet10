//
//  Recipe.swift
//  Reciplease
//
//  Created by Adam Mokhtar on 10/05/2021.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
import Foundation


// MARK: - Welcome
struct SearchResult: Codable {
  let q: String
  let from, to: Int
  let more: Bool
  let count: Int
  let hits: [Hit]
}

// MARK: - Hit
struct Hit: Codable {
  let recipe: Recipe
}

// MARK: - Recipe
struct Recipe: Codable {
  //    let uri: String
  let label: String
  let image: String
  //    let source: String
  let url, shareAs: String
  //    let yield: Int
  let dietLabels, healthLabels, cautions, ingredientLines: [String]
  //    let ingredients: [Ingredient]
  //    let calories, totalWeight: Double
  //    let totalTime: Int
  //    let cuisineType, mealType, dishType: [String]
  //    let totalNutrients, totalDaily: [String: Total]
  //    let digest: [Digest]
}

// MARK: - Digest
struct Digest: Codable {
  let label, tag: String
  let schemaOrgTag: String?
  let total: Double
  let hasRDI: Bool
  let daily: Double
  let unit: Unit
  let sub: [Digest]?
}

enum Unit: String, Codable {
  case empty = "%"
  case g = "g"
  case kcal = "kcal"
  case mg = "mg"
  case µg = "µg"
}

// MARK: - Ingredient
struct Ingredient: Codable {
  let text: String
  let weight: Double
  let foodCategory, foodID: String
  let image: String?

  enum CodingKeys: String, CodingKey {
    case text, weight, foodCategory
    case foodID = "foodId"
    case image
  }
}

// MARK: - Total
struct Total: Codable {
  let label: String
  let quantity: Double
  let unit: Unit
}
