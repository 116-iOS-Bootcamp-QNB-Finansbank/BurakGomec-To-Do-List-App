//
//  TodoInteractor.swift
//  ToDoList
//
//  Created by Burak on 19.10.2021.
//

import Foundation

//Reference to presenter
protocol AnyInteractor {
    var presenter: AnyPresenter? { get set}
    
    func getTodoList()
    func deleteTodoFromCoreData(todo: TodoEntity)
    func deleteTodoNotification(todo: TodoEntity)
}

class TodoInteractor: AnyInteractor {
    var presenter: AnyPresenter?
    
    func getTodoList() {
        let result = CoreDataManager().getTodoList()
        self.presenter?.interactorDidFetchTodoList(with: result)
    }
    
    func deleteTodoFromCoreData(todo: TodoEntity) {
        CoreDataManager().deleteTodo(todo: todo)
    }
    
    func deleteTodoNotification(todo: TodoEntity) {
        LocalNotificationManager().removeScheduledNotification(todo: todo)
    }
}
