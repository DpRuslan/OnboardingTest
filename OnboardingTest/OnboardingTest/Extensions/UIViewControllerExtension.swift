//
//  UIViewControllerExtension.swift
//

import UIKit

extension UIViewController {
    func hasPhysicalHomeBtn() -> Bool {
        return view.safeAreaInsets.bottom == 0
    }
    
    func showErrorAlert(title: String) {
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.dismiss(animated: false)
        }
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true)
    }
}
