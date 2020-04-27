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

class TodoListViewController: UITableViewController {
    
    var listArray = [Item]()
    var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    
    
    @IBAction func addButtonAction(_ sender: UIBarButtonItem) {
        AlertUtility.showAlertWithTextField(self, title: "Add New Today Item", message: "", placeholder: "Add Item") { (text) in
            
            if !text.isEmpty{
                let newItem = Item(context: self.context)
                newItem.title = text
                //newItem.done = false
                self.listArray.append(newItem)
                self.saveItems()
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = listArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listArray[indexPath.row].done = !listArray[indexPath.row].done
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
    
    func loadItems() {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do{
            listArray =  try context.fetch(request)
        }catch{
            print("Error on fething data\(error.localizedDescription)")
        }
    }
}




