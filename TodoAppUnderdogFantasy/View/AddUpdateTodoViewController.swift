//
//  AddUpdateTodoViewController.swift
//  TodoAppUnderdogFantasy
//
//  Created by Usman Ahmed on 29/07/2022.
//

import Foundation
import UIKit

class AddUpdateTodoViewController : UIViewController {
    
    var todo : Todo?
    let viewModel = AddUpdateTodoViewModel(todo: nil)
    @IBOutlet weak var taskDetail : UITextView!
    @IBOutlet weak var statusLbl : UILabel!
    @IBOutlet weak var markComplete : UIButton!
    @IBOutlet weak var deleteTodo : UIButton!
    
    @IBOutlet weak var deleteBtnWidth : NSLayoutConstraint!
    @IBOutlet weak var markCompleteBtnWidth : NSLayoutConstraint!
    
    @IBOutlet weak var taskDetailHeight : NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let todo = todo {
            viewModel.todo = todo
            taskDetail.text = todo.task
            statusLbl.text = todo.status ? "Completed" : "Incomplete"
            deleteBtnWidth.constant = (todo.id != nil) ? 46.0 : 0.0
            markCompleteBtnWidth.constant = todo.status ? 0.0 : 46.0
            deleteTodo.isHidden = (todo.id == nil)
            markComplete.isHidden = todo.status
        } else {
            markCompleteBtnWidth.constant = 0.0
            deleteBtnWidth.constant = 0.0
            deleteTodo.isHidden = true
            markComplete.isHidden = true
            statusLbl.text = ""
        }
        taskDetail.sizeToFit()
        taskDetailHeight.constant = max(20.0, taskDetail.frame.height)
    }
    
    @IBAction func actionOnMarkCompleteBtn() {
        if let todo = viewModel.todo {
            viewModel.markComplete()
            viewModel.saveTodo(task: todo.task ?? "") { (success, message) in
                if success {
                    self.markCompleteBtnWidth.constant = 0.0
                    self.markComplete.isHidden = true
                    self.statusLbl.text = "Completed"
                }
            }
        }
    }
    
    @IBAction func actionOnDeletBtn() {
        viewModel.deleteTodo { success in
            if success {
                let alert = UIAlertController(title: "Success", message: "Todo: deleted successfully", preferredStyle: .alert)
                let actionOkay = UIAlertAction(title: "Okay", style: .default) { _ in
                    self.navigationController?.popToRootViewController(animated: true)
                }
                alert.addAction(actionOkay)
                self.navigationController?.present(alert, animated: true)
            }
        }
    }
    
    @IBAction func actionOnSaveBtn() {
        guard (!taskDetail.text.isEmpty) else {
            let alert = UIAlertController(title: "Warning", message: "Cannot create an empty task!", preferredStyle: .alert)
            let actionOkay = UIAlertAction(title: "Okay", style: .default)
            alert.addAction(actionOkay)
            self.navigationController?.present(alert, animated: true)
            return
        }
        viewModel.saveTodo(task: taskDetail.text) { (success, message) in
            if success {
                let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
                let actionOkay = UIAlertAction(title: "Okay", style: .default) { _ in
                    self.navigationController?.popToRootViewController(animated: true)
                }
                alert.addAction(actionOkay)
                self.navigationController?.present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: "Failure", message: message, preferredStyle: .alert)
                let actionOkay = UIAlertAction(title: "Okay", style: .default)
                alert.addAction(actionOkay)
                self.navigationController?.present(alert, animated: true)
            }
        }
    }
}

extension AddUpdateTodoViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        taskDetail.sizeToFit()
        taskDetailHeight.constant = max(20.0, taskDetail.frame.height)
    }
}
