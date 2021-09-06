//
//  FavoriteViewController.swift
//  Reciplease
//
//  Created by Adam Mokhtar on 05/05/2021.
//

import UIKit
import CoreData

class FavoriteViewController : UIViewController,
                               AlertPresentable{

  //----------------------------------------------------------------------------
  // MARK: - Properties
  //----------------------------------------------------------------------------

  var favoriteRecipes = [CDRecipeFavorite]()

  @IBOutlet weak var favoriteRecipeTableView: UITableView!

  //----------------------------------------------------------------------------
  // MARK: - Methods
  //----------------------------------------------------------------------------

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupForViewWillAppear()
  }

  /// setup for the viewWillAppear
  func setupForViewWillAppear () {
    favoriteRecipes = updateCDRecipe()
    favoriteRecipeTableView.reloadData()
  }

  /// Update favorite recipes list
  /// - Returns: return list of recipes update
  private func updateCDRecipe() -> [CDRecipeFavorite] {
    let request: NSFetchRequest<CDRecipeFavorite> = CDRecipeFavorite.fetchRequest()
    do {
      let recipesFavorites = try AppDelegate.viewContext.fetch(request)
      return recipesFavorites
    }
    catch {
      print(error)
      return [CDRecipeFavorite]()
    }
  }
}

//----------------------------------------------------------------------------
// MARK: - Extension DataSource
//----------------------------------------------------------------------------

extension FavoriteViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return favoriteRecipes.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "RecipeCell",
      for: indexPath
    ) as? RecipeTableViewCell else {
      showError(message: "Celule introuvable")
      return UITableViewCell()
    }
    let recipe = favoriteRecipes[indexPath.row]
    guard let urlImage = recipe.urlImage, let name = recipe.name else {
      showError(message: "Description introuvable")
      return UITableViewCell()
    }
    cell.configure(icon:urlImage, name:name)
    return cell
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
}

//----------------------------------------------------------------------------
// MARK: - Extension Delegate
//----------------------------------------------------------------------------

extension FavoriteViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      AppDelegate.viewContext.delete(favoriteRecipes[indexPath.row])
      favoriteRecipes.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
      do {
        try AppDelegate.viewContext.save()
      }
      catch {
        showError(message: "Erreur de supression")
        print(error.localizedDescription)
      }
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == "FavoriteDescriptionSegue" else {
      showError(message: "Page suivante introuvable")
      return
    }

    guard let detailRecipeViewController = ((segue.destination) as? RecipeDetailViewController) else {
      showError(message: "Page suivante introuvable")
      print("Error Segue detination Recipe Detail View Controller")
      return
    }
    guard let indexPathRecipe = favoriteRecipeTableView.indexPathForSelectedRow else {
      showError(message: "Erreur selection de la celule")
      print("error index path Favorite table view")
      return
    }

    let selectedRecipe = favoriteRecipes[indexPathRecipe.row]
    let imageURLSelected = selectedRecipe.urlImage
    let urlToRecipe = selectedRecipe.url
    let nameRecipe = selectedRecipe.name
    let descriptionRecipe = selectedRecipe.detail

    detailRecipeViewController.nameRecipeDetail = nameRecipe
    detailRecipeViewController.descriptionSegue = descriptionRecipe
    detailRecipeViewController.imageRecipeDescription = imageURLSelected
    detailRecipeViewController.urlToRecipe = urlToRecipe
  }

}
