//
//  ViewController.swift
//  Todoey
//
//  Created by Gabriella Barbieri on 22/10/19.
//  Copyright © 2019 Vinicius Cechin. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var items = ["Comprar suco", "Alimentar Pingo", "Ir jogar laser tag"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row]
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
            } else {
                cell.accessoryType = .checkmark
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            if let name = textField.text, name != "" {
                // Create new todo
                self.items.append(name)
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

