//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Vinicius Cechin on 24/10/19.
//  Copyright © 2019 Vinicius Cechin. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        showAddCategoryPopup()
    }
    
    override func deleteCell(at indexPath: IndexPath) {
        deleteCategory(indexPath)
    }
}

//MARK: - TableView Datasource extension
extension CategoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return buildCategoryCell(tableView, cellForRowAt: indexPath)
    }
}

//MARK: - TableView Delegate extension
extension CategoryViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTodos", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow, let destination = segue.destination as? TodoListViewController, let categories = categories {
            destination.selectedCategory = categories[indexPath.row]
        }
    }
}

//MARK: - Data manipulation extension - View Model
extension CategoryViewController {
    func buildCategoryCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = buildCell(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
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
        if let name = textField.text, name != "" {
            // Create new category
            let newCategory = Category()
            newCategory.name = name
            
            saveCategories(newCategory)
            tableView.reloadData()
        }
    }
    
    func saveCategories(_ category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context, \(error)")
        }
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)

        tableView.reloadData()
    }
    
    func deleteCategory(_ indexPath: IndexPath) {
        if let categoryToDelete = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(categoryToDelete)
                }
            } catch {
                print("Error deleting category, \(error)")
            }        }
    }
}
