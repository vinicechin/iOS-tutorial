//
//  ViewController.swift
//  Todoey
//
//  Created by Gabriella Barbieri on 22/10/19.
//  Copyright © 2019 Vinicius Cechin. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Todos.plist")
    var items = [Todo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTodos()
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return buildTodoCell(tableView, indexPath: indexPath)
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checkTodo(indexPath)
    }

    //MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        showAddTodoPopup()
    }
}

extension TodoListViewController {
    func buildTodoCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = items[indexPath.row]
        cell.textLabel?.text = item.description
        cell.accessoryType = item.checked ? .checkmark : .none
        
        return cell
    }
    
    func checkTodo(_ indexPath: IndexPath) {
        items[indexPath.row].checked = !items[indexPath.row].checked
        saveTodos()
        
        tableView.cellForRow(at: indexPath)?.accessoryType = items[indexPath.row].checked ? .checkmark : .none
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func showAddTodoPopup() {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            if let name = textField.text, name != "" {
                // Create new todo
                let newTodo = Todo()
                newTodo.description = name
                
                self.items.append(newTodo)
                self.saveTodos()
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

extension TodoListViewController {
    func saveTodos() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(self.items)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding todos list, \(error)")
        }
    }
    
    func loadTodos() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            
            do {
                items = try decoder.decode([Todo].self, from: data)
            } catch {
                print("Error decoding todos list, \(error)")
            }
        }
    }
}

