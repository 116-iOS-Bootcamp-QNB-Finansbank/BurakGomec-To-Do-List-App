//
//  TodoDetailViewModel.swift
//  ToDoList
//
//  Created by Burak on 19.10.2021.
//

import Foundation

protocol TodoDetailViewModelDelegate : NSObject {
    func showTodoDetail(todo: TodoEntity)
    func showErrorAlert(error: String) //Todo type?
}

protocol TodoDetailViewModelProtocol {
    var delegate: TodoDetailViewModelDelegate? { get set}
    func viewDidLoad()
    func saveTodo(title: String, detail: String?, completionTime:Date)
}

class TodoDetailViewModel: TodoDetailViewModelProtocol {

    var delegate: TodoDetailViewModelDelegate?
    
    private var todo: TodoEntity?
    
    init(todo: TodoEntity){
        self.todo = todo
    }
    
    init() {
        //It is "addNewTodo" initializer
    }
    
    func viewDidLoad() {
        if let todoElement = todo{
            delegate?.showTodoDetail(todo: todoElement)
        }
        else {
            delegate?.showErrorAlert(error: "Failed to transfer Todo data")
        }
    }
    
    func saveTodo(title: String, detail: String?, completionTime: Date) {
        print("will come")
        print(title, detail, completionTime)
        CoreDataManager().saveTodo(title: title, detail: detail, completionTime: completionTime)
    }
    
    
}
