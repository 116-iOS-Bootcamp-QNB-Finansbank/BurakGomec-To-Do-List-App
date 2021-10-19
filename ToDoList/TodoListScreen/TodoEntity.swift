//
//  TodoEntity.swift
//  ToDoList
//
//  Created by Burak on 19.10.2021.
//

import Foundation

//VIPE(Entity)R = M(Model)VVM
struct TodoEntity {
    let id: UUID
    var title: String
    var detail: String?
    var completionTime: Date
}
