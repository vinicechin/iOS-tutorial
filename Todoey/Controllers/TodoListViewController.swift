//
//  ViewController.swift
//  Todoey
//
//  Created by Gabriella Barbieri on 22/10/19.
//  Copyright © 2019 Vinicius Cechin. All rights reserved.
//

import UIKit
import CoreData

//MARK: - ViewController
class TodoListViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    var items = [Todo]()
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
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return buildTodoCell(tableView, indexPath: indexPath)
    }
    
    //MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checkTodo(indexPath)
    }

    //MARK: Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        showAddTodoPopup()
    }
}

//MARK: - ViewModel
extension TodoListViewController {
    func buildTodoCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = items[indexPath.row]
        cell.textLabel?.text = item.name
        cell.accessoryType = item.checked ? .checkmark : .none
        
        return cell
    }
    
    func checkTodo(_ indexPath: IndexPath) {
//        context?.delete(items[indexPath.row])
//        items.remove(at: indexPath.row)
        
        items[indexPath.row].checked = !items[indexPath.row].checked
        saveTodos()
        
        tableView.cellForRow(at: indexPath)?.accessoryType = items[indexPath.row].checked ? .checkmark : .none
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
        if let name = textField.text, name != "", let context = context {
            // Create new todo
            let newTodo = Todo(context: context)
            newTodo.name = name
            newTodo.checked = false
            newTodo.parent = selectedCategory
            
            items.append(newTodo)
            saveTodos()
            tableView.reloadData()
        }
    }
    
    func saveTodos() {
        do {
            if let context = self.context {
                try context.save()
            }
        } catch {
            print("Error saving context, \(error)")
        }
    }
    
    func loadTodos(_ request: NSFetchRequest<Todo> = Todo.fetchRequest()) {
        guard let name = selectedCategory?.name else {
            return
        }
        
        let categoryPredicate = NSPredicate(format: "parent.name MATCHES %@", name)
        if let requestPredicate = request.predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [requestPredicate, categoryPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            items = try context?.fetch(request) ?? [Todo]()
        } catch {
            print("Error fetching data from context, \(error)")
        }
        
        tableView.reloadData()
    }
}

//MARK: - UISearchBarDelegate extension
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        loadTodos(request)
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

