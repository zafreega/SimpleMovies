//
//  AlertManager.swift
//  SimpleMovies
//
//  Created by Abderrahman Ajid on 27/8/2024.
//

import UIKit

class AlertManager {
    static func showAlert(on viewController: UIViewController, title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
