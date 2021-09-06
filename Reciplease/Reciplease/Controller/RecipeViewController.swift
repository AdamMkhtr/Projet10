//
//  RecipeViewController.swift
//  Reciplease
//
//  Created by Adam Mokhtar on 14/05/2021.
//

import Foundation
import UIKit

class RecipeViewController: UIViewController, AlertPresentable{
  
  //----------------------------------------------------------------------------
  // MARK: - Properties
  //----------------------------------------------------------------------------
  
  var recipes = [Recipe]()
  
  @IBOutlet weak var recipeTableView: UITableView!
  
  //----------------------------------------------------------------------------
  // MARK: - Lifecycle
  //----------------------------------------------------------------------------
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    reload()
  }
  
  func reload() {
    recipeTableView.reloadData()
  }

}

//----------------------------------------------------------------------------
// MARK: - Extension UITableViewDataSource
//----------------------------------------------------------------------------

extension RecipeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return recipes.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? RecipeTableViewCell else {
      print("Error create Cell")
      return UITableViewCell()
    }
    let recipe = recipes[indexPath.row]
    
    cell.configure(icon: recipe.image, name: recipe.label)
    
    return cell
  }
  func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
}

//----------------------------------------------------------------------------
// MARK: - Extension UITableViewDelegate
//----------------------------------------------------------------------------

extension RecipeViewController: UITableViewDelegate {
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == "DetailRecipeSegue" else {
      showError(message: "La page suivante n'a pas été trouvé")
      return
    }
    guard let detailRecipeViewController = ((segue.destination) as? RecipeDetailViewController) else {
      showError(message: "La page suivante n'a pas été trouvé")
      print("error segue destination controller")
      return
    }
    guard let indexPathRecipe = recipeTableView.indexPathForSelectedRow else {
      showError(message: "Erreur selection celule")
      print("error IndexPath")
      return
    }
    
    let selectedRecipe = recipes[indexPathRecipe.row]
    let imageURLSelected = selectedRecipe.image
    let urlToRecipe = selectedRecipe.url
    let nameRecipe = selectedRecipe.label
    var cellSelected = "  - "
    let separator =  "\n  - "
    
    let joinedRecipes = recipes[indexPathRecipe.row]
      .ingredientLines
      .joined(separator: separator)
    
    for recipes in joinedRecipes {
      cellSelected += recipes.description
    }
    
    detailRecipeViewController.nameRecipeDetail = nameRecipe
    detailRecipeViewController.descriptionSegue = cellSelected
    detailRecipeViewController.imageRecipeDescription = imageURLSelected
    detailRecipeViewController.urlToRecipe = urlToRecipe
    
  }
}

