//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var todoItems: Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.register(TodoItemCell.self, forCellReuseIdentifier: "TodoItemCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBarAppearance()
    }
    
    func setupNavBarAppearance() {
        if let category = selectedCategory {
            
            if let navBarColor = UIColor(hexString: category.color)?.lighten(byPercentage: 0.5) {
                
                // navigation bar appearance
                navigationItem.customApperance(color: navBarColor, label: category.name)
                navigationController?.navigationBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)

                // search bar
                searchBar.barTintColor = navBarColor
                searchBar.backgroundColor = navBarColor
                searchBar.searchTextField.backgroundColor = FlatWhite()
                
            }
        }
    }
    
    // MARK: - TableView DataSource Methods 
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath) as! TodoItemCell
        
        // check if realm loded our items
        guard let items = todoItems else {
            cell.textLabel?.text = "No Items Added"
            return cell
        }
        
        let item = items[indexPath.row]
    
        cell.configure(with: item, color: selectedCategory!.color, percentage: CGFloat(indexPath.row)*0.6 / CGFloat(items.count))
                
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done.toggle()
                }
            } catch {
                print("error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alertView = AlertView().loadFromNib() as! AlertView
        alertView.set(title: "Add Item", leftButtonTitle: "Cancel", rightButtonTitle: "Add", showColorOptions: false)
        view.addSubview(alertView)
        self.tableView.isScrollEnabled = false

        alertView.cancelButtonClicked = {
            alertView.animateOut()
            self.tableView.isScrollEnabled = true
        }

        alertView.addButtonClicked = {
            if let text = alertView.alertTextField.text {
                
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = text
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error Saving Items, \(error)")
                    }
                }
            alertView.animateOut()
            self.tableView.isScrollEnabled = true
            self.tableView.reloadData()
                
            } else {
                alertView.alertTextField.placeholder = "Input Category Name"
            }
        }
        
    }
    
// MARK: - Realm Data Methods
    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    

// MARK: - Delete Data From Swipe

    override func deleteRow(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                }
            } catch {
                print("error deleting category, \(error)")
            }
        }
    }
    
}

// MARK: - Search Bar Delegate

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter( "title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            searchBarSearchButtonClicked(searchBar)
        }
    }
}

