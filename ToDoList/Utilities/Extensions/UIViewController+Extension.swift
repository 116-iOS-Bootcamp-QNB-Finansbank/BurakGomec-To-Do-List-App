//
//  UIViewController+Extension.swift
//  ToDoList
//
//  Created by Burak on 15.10.2021.
//

import UIKit

extension UIViewController{
    func showDiscardChangesAlert(completion: @escaping (Bool) -> ()){
        let alert = UIAlertController()
        let discardChangesButton = UIAlertAction(title: "Discard Changes", style: UIAlertAction.Style.destructive) { _ in
            completion(true)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { _ in
            completion(false)
        }
        alert.addAction(discardChangesButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showBasicAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let attributedString = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor : UIColor.red])
        
        alert.setValue(attributedString, forKey: "attributedTitle")
        
        let okButton = UIAlertAction(title: "OK" , style: .default, handler: nil)
        okButton.setValue(UIColor.Custom.basicAlertOkButtonTextColor, forKey: "titleTextColor")
        
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
