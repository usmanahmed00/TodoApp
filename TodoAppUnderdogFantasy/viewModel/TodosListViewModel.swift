//
//  TodosListViewModel.swift
//  TodoAppUnderdogFantasy
//
//  Created by Usman Ahmed on 29/07/2022.
//

import Foundation

class TodosListViewModel {
    
    var todos = [Todo]()
    
    init() {
    }
    
    func getAllTodos() {
        todos = CoreDataService.shared.getAllTodos()
    }
    
    func updateTaskAtIndex(_ index: Int, completion: @escaping (Bool) -> Void) {
        CoreDataService.shared.updateTodo(todo: todos[index], completion: completion)
    }
    
    func deleteTask(_ index: Int, completion: @escaping (Bool) -> Void) {
        CoreDataService.shared.deleteTodo(todo: todos[index], completion: completion)
    }
}
