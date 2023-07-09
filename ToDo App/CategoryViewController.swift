//
//  ViewController.swift
//  ToDo App
//
//  Created by HUSSAM on 7/9/23.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories  = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    
    //MARK: - TabelView Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatogeryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
        /* // Delete Func
         context.delete(categories[indexPath.row])
         categories.remove(at: indexPath.row)
         loadCategories()
         */
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error Saving Category \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error Loading Category \(error)")
        }
        tableView.reloadData()
    }
    
    // MARK: - Add New Category
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Catogery", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            
            self.saveCategories()
        }
        
        alert.addAction(action)
        alert.addTextField { (filed) in
            textField = filed
            textField.placeholder = "Add New Category"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
}
