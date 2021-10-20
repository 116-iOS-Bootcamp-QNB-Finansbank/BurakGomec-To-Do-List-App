//
//  TodoDetailBuilder.swift
//  ToDoList
//
//  Created by Burak on 19.10.2021.
//

import Foundation

class TodoDetailBuilder {
    static func build(with todo: TodoEntity)->TodoDetailViewController{
        let vc = TodoDetailViewController()
        vc.viewModel = TodoDetailViewModel(todo: todo)
        return vc
    }
    
    static func build()->TodoDetailViewController{
        let vc = TodoDetailViewController()
        vc.viewModel = TodoDetailViewModel()
        return vc
    }
}
