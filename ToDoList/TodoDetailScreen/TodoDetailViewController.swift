//
//  DetailViewController.swift
//  ToDoList
//
//  Created by Burak on 15.10.2021.
//

import UIKit

class TodoDetailViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var generalView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    private var newTodoControl: Bool = true
    private var bufferTitleText: String = ""
    private var bufferDetailText: String? = ""
    private var bufferDate: Date = Date()
    private var selectedTodo: TodoEntity?
    
    var viewModel: TodoDetailViewModelProtocol?{
        didSet{
            viewModel?.delegate = self
        }
    }
    
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
        viewModel?.viewDidLoad()
    }
    
    private func hideKeyboard() {
        let endTapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        self.view.addGestureRecognizer(endTapGesture)
    }

    private func prepareNavigationBar() {
        navigationBar.topItem?.title = "Details"
        let leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelTheEditing))
        leftBarButtonItem.tintColor = .red
        let rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveTodo))
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
        self.datePicker.locale = Locale(identifier: "en_GB")
    }
    
    private func prepareTextFields() {
        let font = UIFont(name: "Charter-Black", size: 18)!
        titleTextField.font = font
        detailTextField.font = font
    }
    
    
    @objc func saveTodo(){
        guard let requiredTitle = titleTextField.text, requiredTitle.trimmingCharacters(in: .whitespaces) != "" else {
            return self.showBasicAlert(title: "Error", message: "Please fill the Title field")
            
        }
        if newTodoControl{
            //viewModel?.saveTodo(newTodo: TodoEntity())
            viewModel?.saveTodo(title: requiredTitle, detail: detailTextField.text, completionTime: datePicker.date)
            sendNotificationForTodoUpdate()
        }
        else if checkTodoItemUpdate(){
            viewModel?.updateTodo(todo: selectedTodo!, newTodo: TodoEntity(id: selectedTodo!.id, title: titleTextField.text ?? bufferTitleText,
                                                                           detail: detailTextField.text, completionTime: datePicker.date))
            sendNotificationForTodoUpdate()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    private func checkTodoItemUpdate()->Bool{
        if bufferTitleText != titleTextField.text || bufferDetailText != detailTextField.text || bufferDate != datePicker.date {
            return true
        }
        return false
    }
    
    private func sendNotificationForTodoUpdate(){
        NotificationCenter.default.post(name: .updateTodoList, object: nil)
    }
    
    @objc func cancelTheEditing() {
        if checkTodoItemUpdate() {
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
extension TodoDetailViewController : UITextFieldDelegate {
    
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
}

extension TodoDetailViewController {
    override func viewWillDisappear(_ animated: Bool) {
       //TODO: UIAlertController?
    }
}

//MARK: - TodoDetailViewModelDelegate
extension TodoDetailViewController: TodoDetailViewModelDelegate{
    func showTodoDetail(todo: TodoEntity) {
        newTodoControl = false
        selectedTodo = todo
        
        self.titleTextField.text = todo.title
        self.detailTextField.text = todo.detail
        self.datePicker.date = todo.completionTime //TODO:
        
        self.bufferTitleText = todo.title
        self.bufferDetailText = todo.detail
        self.bufferDate = todo.completionTime
    }
    
    func showErrorAlert(error: String) {
        self.showBasicAlert(title: "Error", message: "An error occurred while retrieving the todo item")
    }
}
