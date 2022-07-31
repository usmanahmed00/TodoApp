//
//  TodoListCellView.swift
//  TodoAppUnderdogFantasy
//
//  Created by Usman Ahmed on 29/07/2022.
//

import Foundation
import UIKit

class TodoListCellView : UITableViewCell {
    override class func awakeFromNib() {
        super .awakeFromNib()
    }
    
    override func prepareForReuse() {
        self.textLabel?.text = ""
        super.prepareForReuse()
    }
    
    var todo : Todo? {
        didSet {
            if let todo = todo {
                self.textLabel?.text = todo.task
                if todo.status {
                    self.textLabel?.textColor = .red
                } else {
                    self.textLabel?.textColor = .black
                }
            }
        }
    }
}
