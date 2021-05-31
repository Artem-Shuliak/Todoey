//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Artem Shuliak  on 2/27/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit

class SwipeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func deleteRow(at indexPath: IndexPath) {
        // the class which inherits this class will override this func to update the model (works like a closure but for overriding superclass)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { (action, view, completion) in
            
            self.deleteRow(at: indexPath)
            
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                completion(true)
            }
        
        deleteAction.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}
