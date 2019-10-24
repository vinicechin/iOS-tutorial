//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Gabriella Barbieri on 24/10/19.
//  Copyright © 2019 Vinicius Cechin. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        showAddCategoryPopup()
    }
}

//MARK: - TableView Datasource extension
extension CategoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return buildCategoryCell(tableView, cellForRowAt: indexPath)
    }
}

//MARK: - TableView Delegate extension
extension CategoryViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTodos", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow, let destination = segue.destination as? TodoListViewController {
            destination.selectedCategory = categories[indexPath.row]
        }
    }
}

//MARK: - Data manipulation extension - View Model
extension CategoryViewController {
    func buildCategoryCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let item = categories[indexPath.row]
        cell.textLabel?.text = item.name
        
        return cell
    }
    
    func showAddCategoryPopup() {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            self.addCategory(textField)
        }
        
        alert.addTextField { (alert) in
            alert.placeholder = "Create new category"
            textField = alert
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func addCategory(_ textField: UITextField) {
        if let name = textField.text, name != "", let context = context {
            // Create new category
            let newCategory = Category(context: context)
            newCategory.name = name
            
            categories.append(newCategory)
            saveCategories()
            tableView.reloadData()
        }
    }
    
    func saveCategories() {
        do {
            if let context = self.context {
                try context.save()
            }
        } catch {
            print("Error saving context, \(error)")
        }
    }
    
    func loadCategories(_ request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context?.fetch(request) ?? [Category]()
        } catch {
            print("Error fetching data from context, \(error)")
        }
        
        tableView.reloadData()
    }
}
