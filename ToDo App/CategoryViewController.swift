//
//  ViewController.swift
//  ToDo App
//
//  Created by HUSSAM on 7/9/23.
//

import UIKit
import CoreData
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    var categories  = [Category]()
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.rowHeight = 80.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.backgroundColor = UIColor(hexString: "481CC3")
        
    }
    
    //MARK: - TabelView Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let category = categories[indexPath.row]
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = category.name ?? "No Categories Added Yet"
        let categoryColour = UIColor(hexString: category.colour)
        cell.backgroundColor = categoryColour
        cell.textLabel?.textColor = ContrastColorOf(backgroundColor: categoryColour!, returnFlat: true)
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
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
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        self.context.delete(self.categories[indexPath.row])
        self.categories.remove(at: indexPath.row)
    }
    
    // MARK: - Add New Category
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Catogery", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat()!.hexValue()
            self.categories.append(newCategory)
            
            self.saveCategories()
        }
        
        alert.addAction(action)
        alert.addTextField { (filed) in
            textField = filed
            textField.placeholder = "Create New Category"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
}
