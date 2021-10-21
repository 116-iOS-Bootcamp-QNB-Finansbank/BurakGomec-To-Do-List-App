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
    func updateTodo(todo: TodoEntity, newTodo: TodoEntity)
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
//        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: completionTime)
//
//        let componentYear = components.year
//        let componentMonth = components.month
//        let componentDay = components.day
//        let componentHour = components.hour!
//        let componentMinute = components.minute!
//
//        print("Year: \(componentYear), month: \(componentMonth), day: \(componentDay), hour: \(componentHour), \(componentMinute)")
//
//        let date = Calendar.current.date(from: components)
//
         CoreDataManager().saveTodo(title: title, detail: detail, completionTime: completionTime)
    }
    
    func updateTodo(todo: TodoEntity, newTodo: TodoEntity) {
        CoreDataManager().updateTodo(todo: todo, newTodo: newTodo)
    }
    
    
    
}
