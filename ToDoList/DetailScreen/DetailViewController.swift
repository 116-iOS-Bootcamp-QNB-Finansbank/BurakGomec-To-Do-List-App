//
//  DetailViewController.swift
//  ToDoList
//
//  Created by Burak on 15.10.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var generalView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    private var discardChangesControl : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        detailTextField.delegate = self
        prepareNavigationBar()
        
        prepareDatePicker()
        prepareGeneralView()
        prepareTextFields()
        hideKeyboard()
        
        view.backgroundColor = UIColor.Custom.generalBackgroundColor
    }
    
    private func hideKeyboard() {
        let endTapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        self.view.addGestureRecognizer(endTapGesture)
    }

    private func prepareNavigationBar() {
        navigationBar.topItem?.title = "Details"
        let leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelTheEditing))
        leftBarButtonItem.tintColor = .red
        let rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        rightBarButtonItem.tintColor = .red
        
        self.navigationBar.topItem?.leftBarButtonItem = leftBarButtonItem
        self.navigationBar.topItem?.rightBarButtonItem = rightBarButtonItem
    }
    
    private func prepareGeneralView() {
        generalView.backgroundColor = UIColor.Custom.stackViewBackgroundColor
        generalView.layer.cornerRadius = 15
      
    }
    
    private func prepareDatePicker() {
        self.datePicker.tintColor = .red
    }
    
    private func prepareTextFields() {
        let font = UIFont(name: "Charter-Black", size: 18)!
        titleTextField.font = font
        detailTextField.font = font
    }
    
    @objc func cancelTheEditing() {
        if discardChangesControl {
            self.showDiscardChangesAlert { result in
                result == true ? self.dismiss(animated: true, completion: nil) : nil
            }
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func endEditing() {
        self.view.endEditing(true)
    }
    
    deinit {
        print("\(self) deinit")
    }
}

//MARK: - UITextFieldDelegate
extension DetailViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchToNextTextField(textField: textField)
        return true
    }
    
    private func switchToNextTextField(textField: UITextField) {
        switch textField {
        case titleTextField:
            detailTextField.becomeFirstResponder()
        default:
            detailTextField.resignFirstResponder()
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        discardChangesControl = true
        return true
    }
}

extension DetailViewController {
    override func viewWillDisappear(_ animated: Bool) {
       //TODO: UIAlertController?
    }
}
