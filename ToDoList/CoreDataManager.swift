//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Burak on 17.10.2021.
//

import UIKit
import CoreData

protocol DataManagerProtocol {
    func getTodoList()->Result<[TodoEntity], Error>
    func updateTodo()
    func deleteTodo()
    func saveTodo(title: String, detail: String?, completionTime:Date)
}

class CoreDataManager: DataManagerProtocol{
    
    func getTodoList()->Result<[TodoEntity], Error>{
        var todoArray : [TodoEntity] = []
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistantContainer = appDelegate.persistentContainer
        let context = persistantContainer.viewContext
        
        let fetchRequest: NSFetchRequest<CoreDataTodoEntity> = CoreDataTodoEntity.fetchRequest()
        do{
            let savedTodos = try context.fetch(fetchRequest)
            for savedTodo in savedTodos{
                if savedTodo.title != nil && savedTodo.completionTime != nil && savedTodo.id != nil {
                    let todo = TodoEntity(id: savedTodo.id!, title: savedTodo.title!, detail: savedTodo.detail, completionTime: savedTodo.completionTime!)
                    todoArray.append(todo)
                }
                
            }
            return .success(todoArray)
        }
        catch let error as NSError{
            print("Could not read. \(error), \(error.userInfo)")
            return .failure(error)
        }
    }
    
    func deleteTodo() {
        //
    }
    
    func saveTodo(title: String, detail: String?, completionTime:Date){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistantContainer = appDelegate.persistentContainer
        let context = persistantContainer.viewContext
        
        let entity = CoreDataTodoEntity(context: context)
        entity.id = UUID()
        entity.title = title
        entity.detail = detail
        //entity.completionTime = completionTime
        do {
            try context.save()
        }
        catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            //TODO: error
        }
    
    }
    
    func updateTodo() {
        //
    }
    
    
}
