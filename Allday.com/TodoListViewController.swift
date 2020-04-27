//
//  ViewController.swift
//  Allday.com
//
//  Created by Danish Khan on 27/04/20.
//  Copyright © 2020 Danish Khan. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class TodoListViewController: UITableViewController{
    
    var itemsArray = [Item]()
    var selectedCategory: CategoryList? {
        didSet{
            loadItems()
        }
    }
    
    
    var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    
    
    @IBAction func addButtonAction(_ sender: UIBarButtonItem) {
        AlertUtility.showAlertWithTextField(self, title: "Add New Today Item", message: "", placeholder: "Add Item") { (text) in
            
            if !text.isEmpty{
                let newItem = Item(context: self.context)
                newItem.title = text
                newItem.parentRelation = self.selectedCategory
                self.itemsArray.append(newItem)
                self.saveItems()
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemsArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemsArray[indexPath.row].done = !itemsArray[indexPath.row].done
        saveItems()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func saveItems() {
        do{
            try context.save()
        }catch{
            print("Error saving context")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(),predicate: NSPredicate? = nil) {
        let categoyPredicate = NSPredicate(format: "parentRelation.name MATCHES %@", selectedCategory!.name!)
        if let addtionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoyPredicate,addtionalPredicate])
        }else{
            request.predicate = categoyPredicate
        }
        
        do{
            itemsArray =  try context.fetch(request)
        }catch{
            print("Error on fething data\(error.localizedDescription)")
        }
        tableView.reloadData()
    }
}

//MARK: - UISearchBarDelegate
extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}


