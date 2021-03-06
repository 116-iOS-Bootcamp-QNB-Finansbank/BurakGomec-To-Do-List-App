//
//  TodoDetailViewModel.swift
//  ToDoList
//
//  Created by Burak on 19.10.2021.
//

import Foundation

protocol TodoDetailViewModelDelegate : NSObject {
    func showTodoDetail(todo: TodoEntity)
    func showErrorAlert(error: String)
}

protocol TodoDetailViewModelProtocol {
    var delegate: TodoDetailViewModelDelegate? { get set}
    func viewDidLoad()
    func saveTodo(title: String, detail: String?, completionTime:Date)
    func updateTodo(todo: TodoEntity, newTodo: TodoEntity)
    func checkTodoItemUpdateResult(bufferTitleText: String, titleText: String?, bufferDetailText: String?, detailText: String?,
                                   bufferDate: Date, date: Date)->Bool
}

class TodoDetailViewModel: TodoDetailViewModelProtocol {
    weak var delegate: TodoDetailViewModelDelegate?
    
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
        let newTodo = TodoEntity(id: UUID(), title: title, detail: detail, completionTime: completionTime, editDate: Date())
        
        CoreDataManager().saveTodo(newTodo: newTodo)
        sendTodoToLocalNotificationManager(newTodo: newTodo)
    }

    private func sendTodoToLocalNotificationManager(newTodo: TodoEntity){
        LocalNotificationManager().scheduleNotification(todo: newTodo)
    }
    
    func updateTodo(todo: TodoEntity, newTodo: TodoEntity) {
        CoreDataManager().updateTodo(todo: todo, newTodo: newTodo)
        LocalNotificationManager().removeScheduledNotification(todo: todo)
        LocalNotificationManager().scheduleNotification(todo: newTodo)
    }
    
    
    func checkTodoItemUpdateResult(bufferTitleText: String, titleText: String?, bufferDetailText: String?, detailText: String?, bufferDate: Date, date: Date) -> Bool {
        if bufferTitleText != titleText || bufferDetailText != detailText || bufferDate != date{
            return true
        }
        return false
    }
    
}
