//
//  CoreDataService.swift
//  TodoAppUnderdogFantasy
//
//  Created by Usman Ahmed on 29/07/2022.
//

import Foundation
import CoreData

class CoreDataService {
    static let shared = CoreDataService()
    
    private init() {}
    
    func deleteTodo(todo: Todo, completion: @escaping (Bool) -> Void) {
        let request = Todo.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", todo.id! as CVarArg)
        do {
            let context = persistentContainer.viewContext
            let result = try context.fetch(request)
            if !result.isEmpty {
                let oldTodo = result.first!
                context.delete(oldTodo)
                saveContext()
                completion(true)
            }
        } catch {
            print("Something went wrong \(error)")
        }
        completion(false)
    }
    
    func updateTodo(todo: Todo, completion: @escaping (Bool) -> Void) {
        let request = Todo.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", todo.id! as CVarArg)
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            if !result.isEmpty {
                let oldTodo = result.first!
                oldTodo.task = todo.task
                oldTodo.updated_at = Date()
                saveContext()
                completion(true)
            }
        } catch {
            print("Something went wrong \(error)")
        }
        completion(false)
    }
    
    func createTodo(task: String, completion: @escaping (Bool) -> Void) {
        let todo = Todo(context: persistentContainer.viewContext)
        todo.id = UUID()
        todo.task = task
        todo.created_at = Date()
        saveContext()
        completion(true)
    }
    
    func getAllTodos () -> [Todo] {
        let request = Todo.fetchRequest()
        let sort = NSSortDescriptor(key: "created_at", ascending: false)
        request.sortDescriptors = [sort]
        var todos = [Todo]()
        
        do {
            todos = try persistentContainer.viewContext.fetch(request)
        } catch {
            print("Something went wrong \(error)")
        }
        
        return todos
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoAppUnderdogFantasy")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("Something went wrong \(error)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Something went wrong \(error)")
            }
        }
    }
}
