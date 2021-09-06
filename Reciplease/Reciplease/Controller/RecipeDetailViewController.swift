//
//  RecipeDetailViewController.swift
//  Reciplease
//
//  Created by Adam Mokhtar on 04/06/2021.
//

import Foundation
import UIKit
import CoreData

class RecipeDetailViewController: UIViewController, AlertPresentable{

  //----------------------------------------------------------------------------
  // MARK: - Properties
  //----------------------------------------------------------------------------

  @IBOutlet weak var detailRecipeLabel: UILabel!
  @IBOutlet weak var imageRecipe: UIImageView!
  @IBOutlet weak var nameRecipe: UILabel!
  @IBOutlet weak var favoriteButton: UIButton!
  @IBOutlet weak var recetteDescriptionButton: UIButton!

  var descriptionSegue: String?
  var imageRecipeDescription: String?
  var urlToRecipe: String?
  var nameRecipeDetail: String?

  //----------------------------------------------------------------------------
  // MARK: - Methods
  //----------------------------------------------------------------------------

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    setupButton()
  }

  /// setup the appearance of the button
  func setupButton () {
    recetteDescriptionButton.layer.cornerRadius = 5
    recetteDescriptionButton.layer.borderWidth = 0.3
  }

  /// Setup of viewDidLoad
  private func setup() {
    guard let imageRecipeDescription = imageRecipeDescription else {
      return
    }
    if checkIfRecipeExist(url: urlToRecipe!) {
      favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
    } else {
      favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
    }
    self.nameRecipe.text = nameRecipeDetail
    self.detailRecipeLabel.text = descriptionSegue
    self.imageRecipe.load(link: imageRecipeDescription)
  }

  //----------------------------------------------------------------------------
  // MARK: - Buttons
  //----------------------------------------------------------------------------

  @IBAction func goToWebSite() {
    guard let urlToRecipe = urlToRecipe,
          let url = URL(string: urlToRecipe) else {
      print("error URL")
      return
    }
    UIApplication.shared.open(url)
  }

  @IBAction func addFavorite() {
    guard let urlToRecipe = urlToRecipe else {
      print("error URL")
      return
    }
    if checkIfRecipeExist(url: String(urlToRecipe)) {
      deleteRecipe(url: urlToRecipe)
      favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
      showToastError(controller: self, message: "Supprimé des favoris", seconds: 0.7)
    } else {
      saveRecipe()
      favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
      showToastError(controller: self, message: "Ajouté aux favoris", seconds: 0.7)
    }
  }

  //----------------------------------------------------------------------------
  // MARK: - Prépare to save on Core Data
  //----------------------------------------------------------------------------

  /// Save the detail of recipe on Core Data
  func saveRecipe() {
    guard let urlToRecipe = urlToRecipe else {
      print("error URL")
      return
    }

    let recipe = CDRecipeFavorite(context: AppDelegate.viewContext)
    recipe.name = nameRecipe.text
    recipe.detail = detailRecipeLabel.text
    recipe.url = urlToRecipe
    recipe.urlImage = imageRecipeDescription
    do {
      try AppDelegate.viewContext.save()
    }
    catch {
      print(error.localizedDescription)
      showError(message: "La recette n'a pas pu être sauvegardé")
    }
  }

  /// Check if recipe exist in Core Data
  /// - Parameter url: is the key for check
  /// - Returns: return true if the recipe exist on Core Data otherwise if false
  func checkIfRecipeExist(url: String) -> Bool {

    let managedContext = AppDelegate.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDRecipeFavorite")
    fetchRequest.fetchLimit =  1
    fetchRequest.predicate = NSPredicate(format: "url == %@" ,url)
    do {
      let count = try managedContext.count(for: fetchRequest)
      if count > 0 {
        return true
      }else {
        return false
      }
    }catch let error {
      print("Could not fetch. \(error)")
      return false
    }
  }

  /// delete the recipe if this one is already on core data
  /// - Parameter url: use url of the recipe for sort the recipe
  func deleteRecipe(url: String) {
    let request = AppDelegate.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDRecipeFavorite")
    fetchRequest.predicate = NSPredicate(format: "url == %@" ,url)

    do {
      let objects = try request.fetch(fetchRequest)
      for object in objects {
        request.delete(object)
      }
      try request.save()

    } catch {
      print(error)
    }
  }
}

