//
//  TodoDetailPresentation.swift
//  ToDoList
//
//  Created by Burak on 21.10.2021.
//

import Foundation

struct TodoDetailPresentation{
    let id: UUID
    var title: String
    var detail: String?
    var completionTime: Date
    
    init(id: UUID, title: String, detail: String?, completionTime: Date) {
        self.id = id
        self.title = title
        self.detail = detail
        self.completionTime = completionTime
    }
    
    init(todo: TodoEntity) {
        self.id = todo.id
        self.title = todo.title
        self.detail = todo.detail
        self.completionTime = todo.completionTime
    }
}


