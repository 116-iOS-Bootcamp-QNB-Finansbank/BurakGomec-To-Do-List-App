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
    func interactorDidSortTodoList(with list: [TodoEntity])
    func addNewToDoItem()
    func deleteTodo(todo: TodoEntity)
    func sortTodoListByEarliestFirst()
    func sortTodoListByLatestFirst()
    func filterTodoListBySearchText(searchText: String)
    func getSavedTodoList()
    func deleteAllTodo()
}

class TodoPresenter: AnyPresenter{
    var view: AnyView?
    var router: AnyRouter?
    var interactor: AnyInteractor?
    
    func viewDidLoad() {
        interactor?.getTodoList()
    }
    
    func didSelectRow(todo: TodoEntity) {
        router?.navigate(to: .showTodoDetail(TodoEntity(id: todo.id, title:todo.title, detail: todo.detail, completionTime: todo.completionTime, editDate: todo.editDate)))
    }
    
    func interactorDidFetchTodoList(with result: Result<[TodoEntity], Error>) {
        switch result {
        case .success(let todoList):
            view?.showTodoList(with: todoList)
        case .failure(let error):
            view?.showTodoList(with: error)
        }
    }
    
    func addNewToDoItem() {
        router?.navigate(to: .addNewTodo)
    }
    
    func deleteTodo(todo: TodoEntity) {
        interactor?.deleteTodoFromCoreData(todo: todo)
        interactor?.deleteTodoNotification(todo: todo)
    }
    
    func sortTodoListByEarliestFirst() {
        guard let sortedArray = interactor?.sortTodoListByEarliestFirst() else { return }
        view?.showTodoList(with: sortedArray)
    }
    
    func sortTodoListByLatestFirst() {
        guard let sortedArray = interactor?.sortTodoListByLatestFirst() else { return }
        view?.showTodoList(with: sortedArray)
    }

    func interactorDidSortTodoList(with list: [TodoEntity]) {
        view?.showTodoList(with: list)
    }
    
    func filterTodoListBySearchText(searchText: String) {
        guard let filteredTodoArray = interactor?.filterTodoListBySearchText(searchText: searchText) else { return }
        view?.showTodoList(with: filteredTodoArray)
    }
    
    func getSavedTodoList() {
        guard let savedTodoList = interactor?.getSavedTodoList() else { return }
        view?.showTodoList(with: savedTodoList)
    }
    
    func deleteAllTodo() {
        interactor?.deleteAllTodo()
        view?.showTodoList(with: [])
    }
    
    
}



