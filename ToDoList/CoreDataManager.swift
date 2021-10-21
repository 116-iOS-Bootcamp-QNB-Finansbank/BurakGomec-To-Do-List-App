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
    func updateTodo(todo: TodoEntity, newTodo: TodoEntity)
    func deleteTodo(todo: TodoEntity)
    func saveTodo(title: String, detail: String?, completionTime:Date)
}

enum CoreDataAttributeKeys : String{
    case id = "id"
    case title = "title"
    case detail = "detail"
    case completionTime = "completionTime"
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
            print("Could not read(getTodoList method) \(error), \(error.userInfo)")
            return .failure(error)
        }
    }
    
    func deleteTodo(todo: TodoEntity) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistantContainer = appDelegate.persistentContainer
        let context = persistantContainer.viewContext
        
        let fetchRequest: NSFetchRequest<CoreDataTodoEntity> = CoreDataTodoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", todo.id as CVarArg)
        
        do {
            let todoArray = try context.fetch(fetchRequest)
            
            if todoArray.count == 1
            {
                let objectDelete = todoArray.first!
                context.delete(objectDelete)
            }
            
            do {
                try context.save()
            }
            catch let error as NSError{
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
        catch let error as NSError{
            print("Could not fetch request.(deleteTodo method) \(error), \(error.userInfo)")
        }
    }
    
    func saveTodo(title: String, detail: String?, completionTime:Date){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistantContainer = appDelegate.persistentContainer
        let context = persistantContainer.viewContext
        
        let entity = CoreDataTodoEntity(context: context)
        entity.id = UUID()
        entity.title = title
        entity.detail = detail
        entity.completionTime = completionTime
        do {
            try context.save()
        }
        catch let error as NSError {
            print("Could not save(saveTodo method) \(error), \(error.userInfo)")
            //TODO: error
        }
    
    }
    
    func updateTodo(todo: TodoEntity, newTodo: TodoEntity) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistantContainer = appDelegate.persistentContainer
        let context = persistantContainer.viewContext
        
        let fetchRequest: NSFetchRequest<CoreDataTodoEntity> = CoreDataTodoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", todo.id as CVarArg)
        
        do {
            let todoArray = try context.fetch(fetchRequest)
            if todoArray.count == 1
            {
                let todoObject = todoArray.first
                todoObject?.setValue(newTodo.title, forKey: CoreDataAttributeKeys.title.rawValue)
                todoObject?.setValue(newTodo.detail, forKey: CoreDataAttributeKeys.detail.rawValue)
                todoObject?.setValue(newTodo.completionTime, forKey: CoreDataAttributeKeys.completionTime.rawValue)
                
                do {
                    try context.save()
                }
                catch let error as NSError{
                    print("Could not save. \(error)")
                }
            }
        }
        catch let error as NSError{
            print("Could not fetch request.(updateTodo method) \(error), \(error.userInfo)")
        }
        
    
    }
    
    
}

