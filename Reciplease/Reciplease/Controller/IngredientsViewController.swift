//
//  ViewController.swift
//  Reciplease
//
//  Created by Adam Mokhtar on 05/05/2021.
//

import UIKit

class IngredientsViewController: UIViewController,
                                 AlertPresentable{
  
  //----------------------------------------------------------------------------
  // MARK: - Outlet
  //----------------------------------------------------------------------------
  
  private let recipeConverter = RecipeConverter()
  private var selectedIngredients = [String]()
  @IBOutlet weak var searchButton: UIButton!
  @IBOutlet weak var addButton: UIButton!
  @IBOutlet weak var clearButton: UIButton!
  @IBOutlet weak var ingredientTextField: UITextField!
  @IBOutlet weak var IngredientTableView: UITableView!
  var currentlyResearching = false
  
  //----------------------------------------------------------------------------
  // MARK: - Method
  //----------------------------------------------------------------------------
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupButton()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    updateResearchingStatus()
  }
  
  /// update currentlyResearching for avoir multiple request
  func updateResearchingStatus() {
    currentlyResearching = false
  }
  
  /// setup the apparance of buttons
  func setupButton() {
    searchButton.layer.cornerRadius = 5
    searchButton.layer.borderWidth = 0.3
    addButton.layer.cornerRadius = 5
    addButton.layer.borderWidth = 0.3
    clearButton.layer.cornerRadius = 5
    clearButton.layer.borderWidth = 0.3
  }
  
  @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
    view.endEditing(true)
  }
  
  @IBAction func saveIngredient() {
    guard let ingredientName = ingredientTextField.text else {
      showError(message: "Aucun ingrédient n'a été trouvé")
      return
    }
    guard ingredientName != "" else {
      showError(message: "Insérez un ingrédient")
      return
    }
    selectedIngredients.append(ingredientName)
    IngredientTableView.reloadData()
    ingredientTextField.text = ""
    view.endEditing(true)
  }
  
  @IBAction func searchRecipe(_ sender: Any) {
    guard currentlyResearching == false else {
      showError(message: "Une recherche est déjà en cours")
      return
    }
    currentlyResearching = true
    var ingredientList = ""
    for recipes in selectedIngredients.joined(separator: ","){
      ingredientList += recipes.description
      print(ingredientList)
    }
    recipeConverter.convert(query: ingredientList) { [weak self] result in
      switch result {
      
      case .success(_):
        guard let count = self?.recipeConverter.recipes.count, count > 0 else {
          self?.showError(message: "Aucune recette n'a été trouvé")
          self?.updateResearchingStatus()
          return
        }
        self?.performSegue(withIdentifier: "RecipeListSegue", sender: .none)
        
      case .failure(let error):
        guard let recipeConverterErrror = error as? RecipeConverter.RecipeConverterError else {
          self?.showError(message: "Une erreur est survenue durant la recherche de recette")
          self?.updateResearchingStatus()
          return
        }
        
        switch recipeConverterErrror {
        case .noResponse:
          self?.showError(message: "Aucun résultat n'a été trouvé")
          self?.updateResearchingStatus()
        }
      }
    }
    view.endEditing(true)
  }
  
  
  @IBAction func clearIngredient() {
    selectedIngredients.removeAll()
    IngredientTableView.reloadData()
  }
}

//----------------------------------------------------------------------------
// MARK: - Extension DataSource Table View
//----------------------------------------------------------------------------

extension IngredientsViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell",
                                             for: indexPath)
    let index = indexPath.row
    
    guard selectedIngredients.count >  index else {
      showError(message: "Erreur ingrédient selectionné")
      return UITableViewCell()
    }
    
    let ingredient = selectedIngredients[index]
    cell.textLabel?.text = ingredient.description
    
    return cell
  }
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return selectedIngredients.count
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
}

//----------------------------------------------------------------------------
// MARK: - Extension Delegate Table View
//----------------------------------------------------------------------------

extension IngredientsViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView,
                 commit editingStyle: UITableViewCell.EditingStyle,
                 forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      selectedIngredients.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == "RecipeListSegue" else {
      print("error identifier segue Recipe List Segue")
      showError(message: "La page suivante n'a pas été trouvé")
      return
    }
    guard let recipeViewController =
            ((segue.destination) as? RecipeViewController) else {
      print("error segue destination")
      showError(message: "La page suivante n'a pas été trouvé")
      return
    }
    recipeViewController.recipes = recipeConverter.recipes
  }
  
}

