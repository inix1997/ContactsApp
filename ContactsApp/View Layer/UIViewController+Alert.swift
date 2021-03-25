//
//  UIViewController+Alert.swift
//  ContactsApp
//
//  Created by Ignacio Segui on 25/03/2021.
//

import UIKit
import PMAlertController

extension UIViewController {    
    
    public func showAlert(title: String?, message: String?) {
        let alertVC = PMAlertController(title: title, description: message, image: nil, style: .alert)
        alertVC.addAction(PMAlertAction(title: Constants.okString, style: .default, action: { () in
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    
}
