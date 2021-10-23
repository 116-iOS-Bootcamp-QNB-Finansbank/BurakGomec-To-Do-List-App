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
    func getSavedTodoList()->[TodoEntity]
    func deleteTodoFromCoreData(todo: TodoEntity)
    func deleteTodoNotification(todo: TodoEntity)
    func sortTodoListByEarliestFirst()->[TodoEntity]
    func sortTodoListByLatestFirst()->[TodoEntity]
    func filterTodoListBySearchText(searchText: String)->[TodoEntity]
}

class TodoInteractor: AnyInteractor {
    var presenter: AnyPresenter?
    private var todoList : [TodoEntity] = []
    
    func getTodoList() {
        let result = CoreDataManager().getTodoList()
        self.presenter?.interactorDidFetchTodoList(with: result)
        
        switch result {
        case .success(let todoList):
            self.todoList = todoList
        case .failure(let error):
            print(error.localizedDescription)
        }

    }
    
    func deleteTodoFromCoreData(todo: TodoEntity) {
        CoreDataManager().deleteTodo(todo: todo)
    }
    
    func deleteTodoNotification(todo: TodoEntity) {
        LocalNotificationManager().removeScheduledNotification(todo: todo)
    }
    
    func sortTodoListByEarliestFirst()->[TodoEntity]{
        let sortedTodoList = todoList.sorted {
            $0.editDate < $1.editDate
        }
        return sortedTodoList
    }
    
    func sortTodoListByLatestFirst()->[TodoEntity]{
        let sortedTodoList = todoList.sorted {
            return $0.editDate > $1.editDate
        }
        return sortedTodoList
    }
    
    func filterTodoListBySearchText(searchText: String)->[TodoEntity]{
        return todoList.filter { (todo) in
            return todo.title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
    }
    
    func getSavedTodoList() -> [TodoEntity] {
        return todoList
    }
    
    
}
