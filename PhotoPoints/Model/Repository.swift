//
//  Repository.swift
//  PhotoPoints
//
//  Description:
//  An interface layer between the UI, the local database, and the API

import Foundation
import UIKit
import CoreData

class Repository {
    
    // MARK: - Definition / Init
    
    // Repository is a singleton, access using Repository.instance
    public static let instance = Repository()
    
    // create a queue for operations requiring thread safety
    private let serialQueue = DispatchQueue(label: "repoQueue")
    
    // get managed context so we can save to core data persistent container
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func loadInitData() {
        
        // build mock database
        MockDatabase.build()
        
        // write to core data
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        // test to see how many rows are in each entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        do {
            let count = try context.count(for: fetchRequest)
            print("Item rows: \(count)")
        } catch {
            print(error.localizedDescription)
        }
    }

    // MARK: - Data Retrieval
    
    func getItems() -> [Item]? {
        if let items = try? context.fetch(Item.fetchRequest()) as [Item] {
            return items
        } else {
            return nil
        }
    }
    
    func getImage(item: Item) -> UIImage? {
        let request = Image.fetchRequest() as NSFetchRequest<Image>
        let predicate = NSPredicate(format: "item == %@", item)
        request.predicate = predicate
        
        if let image = try? context.fetch(request).first {
            return UIImage(named: "\(image.filename).png")
        }
        
        return nil
    }
    
    func getDetailValue(item: Item, property: String) -> String? {
        let request = Detail.fetchRequest() as NSFetchRequest<Detail>
        let predicate = NSPredicate(format: "item == %@ AND property == %@", item, property)
        request.predicate = predicate
        
        if let detail = try? context.fetch(request).first {
            return detail.value
        }
        
        return nil
    }
    
    func getItemFrom(url: String) -> Item? {
        let request = Item.fetchRequest() as NSFetchRequest<Item>
        let predicate = NSPredicate(format: "url == %@", url)
        request.predicate = predicate
        
        if let item = try? context.fetch(request).first {
            return item
        }
        
        return nil
    }
    
}
