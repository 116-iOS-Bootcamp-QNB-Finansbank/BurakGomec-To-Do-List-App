//
//  TodoPresenter.swift
//  ToDoList
//
//  Created by Burak on 19.10.2021.
//

import Foundation

//Reference to view(View Controller), router, interactor
protocol AnyPresenter{
    var view: AnyView? { get set }
    var router: AnyRouter? { get set}
    var interactor: AnyInteractor? { get set}
    
    func viewDidLoad()
    func didSelectRow(at indexPath: IndexPath)
    func didSelectRow(with todo: TodoEntity)
    func interactorDidFetchTodoList(with result: Result<[TodoEntity], Error>)
    func addNewToDoItem()
}

class TodoPresenter: AnyPresenter{
    var view: AnyView?
    var router: AnyRouter?
    var interactor: AnyInteractor?
    
    func viewDidLoad() {
        interactor?.getTodoList()
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        router?.navigate(to: .showTodoDetail(TodoEntity(id: UUID(), title: "XX", detail: "YY", completionTime: Date(timeIntervalSince1970: 121))))
    }
    
    func didSelectRow(with todo: TodoEntity) {
        router?.navigate(to: .showTodoDetail(TodoEntity(id: UUID(), title: "XX", detail: "YY", completionTime: Date(timeIntervalSince1970: 121))))
    }
    

    func interactorDidFetchTodoList(with result: Result<[TodoEntity], Error>) {
        switch result {
        case .success(let todoList):
            view?.getTodoList(with: todoList)
        case .failure(let error):
            view?.getTodoList(with: error)
        }
    }
    
    func addNewToDoItem() {
        router?.navigate(to: .addNewTodo)
    }
    
    
}



