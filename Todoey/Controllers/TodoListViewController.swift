//
//  ViewController.swift
//  Todoey
//
//  Created by Vinicius Cechin on 22/10/19.
//  Copyright © 2019 Vinicius Cechin. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

//MARK: - ViewController
class TodoListViewController: SwipeTableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    var todos: Results<Todo>?
    let realm = try! Realm()
    var selectedCategory: Category? {
        didSet {
            loadTodos()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    }

    //MARK: TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return buildTodoCell(tableView, indexPath: indexPath)
    }
    
    //MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checkTodo(indexPath)
    }

    //MARK: Add new todos
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        showAddTodoPopup()
    }
    
    override func deleteCell(at indexPath: IndexPath) {
        deleteTodo(indexPath)
    }
}

//MARK: - ViewModel
extension TodoListViewController {
    func buildTodoCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = buildCell(tableView, cellForRowAt: indexPath)
        
        let item = todos?[indexPath.row]
        cell.textLabel?.text = item?.name ?? "No items added"
        cell.accessoryType = (item?.checked ?? false) ? .checkmark : .none
        
        return cell
    }
    
    func checkTodo(_ indexPath: IndexPath) {
        if let todo = todos?[indexPath.row] {
            do {
                try realm.write {
                    todo.checked = !todo.checked
                }
            } catch {
                print("Error saving checked status, \(error)")
            }
            
            tableView.cellForRow(at: indexPath)?.accessoryType = todo.checked ? .checkmark : .none
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func showAddTodoPopup() {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            self.addTodo(textField)
        }
        
        alert.addTextField { (alert) in
            alert.placeholder = "Create new item"
            textField = alert
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func addTodo(_ textField: UITextField) {
        if let name = textField.text, name != "" {
            do {
                try realm.write {
                    let newTodo = Todo()
                    newTodo.name = name
                    newTodo.creationDate = Date()
                    selectedCategory?.todos.append(newTodo)
                }
            } catch {
                print("Error saving context, \(error)")
            }
            tableView.reloadData()
        }
    }
    
    func loadTodos() {
        todos = selectedCategory?.todos.sorted(byKeyPath: "creationDate", ascending: true)
        tableView.reloadData()
    }
    
    func deleteTodo(_ indexPath: IndexPath) {
        if let todoToDelete = todos?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(todoToDelete)
                }
            } catch {
                print("Error deleting todo, \(error)")
            }
        }
    }
}

//MARK: - UISearchBarDelegate extension
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todos = todos?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadTodos()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

