//
//  ViewController.swift
//  Todoey
//
//  Created by Gabriella Barbieri on 22/10/19.
//  Copyright © 2019 Vinicius Cechin. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    let defaults = UserDefaults.standard
    var items = [Todo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var newItem = Todo()
        newItem.description = "Comprar suco"
        items.append(newItem)
        
        newItem = Todo()
        newItem.description = "Alimentar Pingo"
        items.append(newItem)
        
        newItem = Todo()
        newItem.description = "Ir jogar laser tag"
        items.append(newItem)
        
//        if let todosList = defaults.array(forKey: "TodosList") as? [Todo] {
//            items = todosList
//        }
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = items[indexPath.row]
        cell.textLabel?.text = item.description
        cell.accessoryType = item.checked ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].checked = !items[indexPath.row].checked
        tableView.cellForRow(at: indexPath)?.accessoryType = items[indexPath.row].checked ? .checkmark : .none
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            if let name = textField.text, name != "" {
                // Create new todo
                let newTodo = Todo()
                newTodo.description = name
                
                self.items.append(newTodo)
//                self.defaults.set(self.items, forKey: "TodosList")
                
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (alert) in
            alert.placeholder = "Create new item"
            textField = alert
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

