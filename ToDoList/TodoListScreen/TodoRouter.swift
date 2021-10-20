//
//  TodoRouter.swift
//  ToDoList
//
//  Created by Burak on 19.10.2021.
//

import UIKit

//Reference to view
protocol AnyRouter{
    //var view: AnyView? { get set }
    var entry: EntryPoint? { get }
    
    func start()->AnyRouter
    func navigate(to route: TodoRoute)
}

enum TodoRoute{
    case showTodoDetail(TodoEntity)
    case addNewTodo
}

typealias EntryPoint = AnyView & UIViewController

class TodoRouter: AnyRouter {
    var entry: EntryPoint?
    private var view: AnyView?

    
     func start() -> AnyRouter {
        let router = TodoRouter()
        
        view = TodoListViewController()
        
        
        var interactor: AnyInteractor = TodoInteractor()
        var presenter: AnyPresenter = TodoPresenter()
        
        view?.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        router.entry = view as? EntryPoint
        
        return router
    }
    
    
    
    func navigate(to route: TodoRoute) {
        switch route {
        case .showTodoDetail(let todo):
            entry?.present(TodoDetailBuilder.build(with: todo), animated: true, completion: nil)
        case .addNewTodo:
            entry?.present(TodoDetailBuilder.build(), animated: true, completion: nil)
        }
    }
    
    
}

