//
//  CategoryViewController.swift
//  Allday.com
//
//  Created by Danish Khan on 27/04/20.
//  Copyright © 2020 Danish Khan. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [CategoryList]()
       var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
       let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()

    }
    
    
    @IBAction func addCategoryTapped(_ sender: UIBarButtonItem) {
        AlertUtility.showAlertWithTextField(self, title: "Add New Category", message: "", placeholder: "Add Category") { (text) in
            
            if !text.isEmpty{
                let newItem = CategoryList(context: self.context)
                newItem.name = text
                self.categoryArray.append(newItem)
                self.saveItems()
                self.tableView.reloadData()
            }
        }

    }
    
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
  
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let item = categoryArray[indexPath.row]
        cell.textLabel?.text = item.name
        
        //cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC?.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    func saveItems() {
        do{
            try context.save()
        }catch{
            print("Error saving context")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<CategoryList> = CategoryList.fetchRequest()) {
        do{
            categoryArray =  try context.fetch(request)
        }catch{
            print("Error on fething data\(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
