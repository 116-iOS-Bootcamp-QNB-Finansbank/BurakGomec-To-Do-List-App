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
}

class TodoInteractor: AnyInteractor {
    var presenter: AnyPresenter?
    
    func getTodoList() {
        //CoreDataManager().saveTodo()
        let result = CoreDataManager().getTodoList()
        presenter?.interactorDidFetchTodoList(with: result)
    }
    
    
}
