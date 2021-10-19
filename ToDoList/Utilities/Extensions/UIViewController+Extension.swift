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
}
