//
//  AddUpdateTodoViewModel.swift
//  TodoAppUnderdogFantasy
//
//  Created by Usman Ahmed on 29/07/2022.
//

import Foundation

class AddUpdateTodoViewModel {
    var todo : Todo?
    
    init(todo: Todo?) {
        self.todo = todo
    }
    
    func markComplete() {
        if let todo = todo {
            todo.status = true
            todo.completed_at = Date()
        }
    }
    
    func saveTodo(task : String, completion: @escaping (Bool, String) -> Void) {
        if let todo = todo {
            todo.task = task
            CoreDataService.shared.updateTodo(todo: todo) { success in
                if success {
                    completion(success, "Todo: updated successfully")
                }
                completion(success, "Failed to update the todo")
            }
        } else {
            CoreDataService.shared.createTodo(task: task) { success in
                if success {
                    completion(success, "Todo: created successfully")
                }
                completion(success, "Failed to create the todo")
            }
        }
    }
    
    func deleteTodo(completion: @escaping (Bool) -> Void) {
        if let todo = todo {
            CoreDataService.shared.deleteTodo(todo: todo, completion: completion)
        }
    }
}
