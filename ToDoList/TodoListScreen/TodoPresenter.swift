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
    func didSelectRow(todo: TodoEntity)
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
    
    func didSelectRow(todo: TodoEntity) {
        router?.navigate(to: .showTodoDetail(TodoEntity(id: todo.id, title:todo.title, detail: todo.detail, completionTime: todo.completionTime)))
    }
    

    func interactorDidFetchTodoList(with result: Result<[TodoEntity], Error>) {
        switch result {
        case .success(let todoList):
            print(todoList)
            view?.getTodoList(with: todoList)
        case .failure(let error):
            view?.getTodoList(with: error)
        }
    }
    
    func addNewToDoItem() {
        router?.navigate(to: .addNewTodo)
    }
    
    
}



