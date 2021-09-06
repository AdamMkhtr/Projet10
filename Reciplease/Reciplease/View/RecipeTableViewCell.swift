//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Adam Mokhtar on 31/05/2021.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

  //----------------------------------------------------------------------------
  // MARK: - Properties
  //----------------------------------------------------------------------------

  @IBOutlet weak var nameRecipeLabel: UILabel!
  @IBOutlet weak var imageRecipe: UIImageView!

  //----------------------------------------------------------------------------
  // MARK: - Method
  //----------------------------------------------------------------------------

  override func awakeFromNib() {
    super.awakeFromNib()
    
    // Initialization code
  }

  /// configure the cell
  /// - Parameters:
  ///   - icon: link of the icon
  ///   - name: name for the cell
  func configure(icon: String, name: String) {
    imageRecipe.load(link: icon)
    nameRecipeLabel.text = name
  }
}
