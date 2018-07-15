//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Wei Wen on 7/8/18.
//  Copyright © 2018 Wei Wen. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categoryArray : Results<Category>?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
        tableView.separatorStyle = .none
    }

    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added Yet"
        if let backColor = categoryArray?[indexPath.row].backgroundColor {
            cell.backgroundColor = UIColor(hexString: backColor)
            cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: backColor)!, returnFlat: true)
        
        } else {
            let newBackColorCode = UIColor.randomFlat.hexValue()
            
            cell.backgroundColor = UIColor(hexString: newBackColorCode)
            cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: newBackColorCode)!, returnFlat: true)
            
            do {
                try realm.write {
                    categoryArray?[indexPath.row].backgroundColor = newBackColorCode
                }
            } catch {
                print("update category error: \(error)")
            }
        }
        
        return cell
    }
   
    
    //MARK: - Data Manipulation Methods
    func loadCategories() {

        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
            
        } catch {
            print("Save categories error: \(error)")
        }
    }
    
    //MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        do {
            try self.realm.write {
                if let categoryToDelete = self.categoryArray?[indexPath.row] {
                    self.realm.delete(categoryToDelete)
                }
            }
        } catch {
            print("Error deleting row \(error)")
        }
    }
    
    
    

    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.backgroundColor = UIColor.randomFlat.hexValue()
            
            self.save(category: newCategory)
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated:true, completion: nil)
        
    
    }
    
    
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
}

