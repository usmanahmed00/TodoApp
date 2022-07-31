//
//  TodosListViewController.swift
//  TodoAppUnderdogFantasy
//
//  Created by Usman Ahmed on 29/07/2022.
//

import Foundation
import UIKit

let infoStr = "There is no task added yet, please tap on the plus button in top right corner to add your first task"

class TodosListViewController : UIViewController {
    @IBOutlet weak var tableView : UITableView!
    let viewModel = TodosListViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAllTodos()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTodo" {
            let target = segue.destination as! AddUpdateTodoViewController
            let todo = (sender as! TodoListCellView).todo
            target.todo = todo
        }
    }
}

extension TodosListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.todos.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let width = UIScreen.main.bounds.width
        let height = infoStr.height(width - 40.0, minHeight: 20.0, font: .systemFont(ofSize: 14.0))
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height+16.0))
        let infoLbl = UILabel(frame: CGRect(x: 20.0, y: 8.0, width: width - 40.0, height: height))
        infoLbl.text = infoStr
        infoLbl.font = .systemFont(ofSize: 14.0)
        infoLbl.numberOfLines = 0
        infoLbl.lineBreakMode = .byWordWrapping
        infoLbl.sizeToFit()
        headerView.addSubview(infoLbl)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if viewModel.todos.isEmpty {
            let maxWidth = UIScreen.main.bounds.width - 40.0
            return infoStr.height(maxWidth, minHeight: 20.0, font: .systemFont(ofSize: 14.0)) + 16.0
        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let todo = viewModel.todos[indexPath.row]
        let maxWidth = UIScreen.main.bounds.width - 60.0
        return todo.task!.height(maxWidth, minHeight: 20.0, font: .systemFont(ofSize: 14.0)) + 16.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell") as! TodoListCellView
        cell.todo = viewModel.todos[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let todo = viewModel.todos[indexPath.row]
        if !todo.status {
            let markCompleteAction = UIContextualAction(style: .normal, title: "Complete") { (action, sourceView, completionHandler) in
                todo.status = true
                self.viewModel.updateTaskAtIndex(indexPath.row) { success in
                    if success {
                        tableView.reloadData()
                    }
                }
            }
            markCompleteAction.backgroundColor = .green
            return UISwipeActionsConfiguration(actions: [markCompleteAction])
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteTask(indexPath.row) { success in
                if success {
                    self.viewModel.getAllTodos()
                    tableView.deleteRows(at: [indexPath], with: .left)
                }
            }
        }
    }
}
