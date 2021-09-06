//
//  Extension.swift
//  Reciplease
//
//  Created by Adam Mokhtar on 01/06/2021.
//

import Foundation
import UIKit


//----------------------------------------------------------------------------
// MARK: - Extension Image view
//----------------------------------------------------------------------------


extension UIImageView {

  /// upload image with url
  /// - Parameter link: url for upload
  func load(link: String) {
    guard  let url = URL(string: link) else {
      return
    }
    DispatchQueue.global().async { [weak self] in
      guard let data = try? Data(contentsOf: url) else {
        return
      }
      guard let image = UIImage(data: data) else {
        return
      }
      DispatchQueue.main.async {
        self?.image = image
      }
    }
  }
}

//----------------------------------------------------------------------------
// MARK: - Extension Controller Alert
//----------------------------------------------------------------------------


protocol AlertPresentable {

  func showError(message: String)
  func showToastError(controller: UIViewController, message: String, seconds: Double)
}

extension AlertPresentable where Self: UIViewController {
  /// Present alerte.
  /// - Parameter message: Choose message.
  func showError(message: String) {
    let alertVC = UIAlertController(title: "Erreur !",
                                    message: message,
                                    preferredStyle: .alert)
    alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alertVC, animated: true, completion: nil)
  }


  /// Present toast alert
  /// - Parameters:
  ///   - controller: select the controller
  ///   - message: message alert
  ///   - seconds: time aften alert diapear
  func showToastError(controller: UIViewController, message: String, seconds: Double){
    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    alert.view.backgroundColor = UIColor.black
    alert.view.alpha = 0.6
    alert.view.layer.cornerRadius = 15

    controller.present(alert, animated: true)

    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
      alert.dismiss(animated: true)
    }
  }
}
