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
        
        // clear data
        clearData(entityNames: ["Coordinate", "Detail", "Image", "Item"])
        
        // build mock database
        MockDatabase.build()
        
        // write to core data
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        // load images to filesystem
        loadInitImages()
    
    }
    
    func clearData(entityNames: [String]) {
        for entity in entityNames {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let deleteReq = NSBatchDeleteRequest(fetchRequest: request)
            do {
                try context.execute(deleteReq)
            } catch {
                print(error)
            }
        }
    }
    
    // load initial images from xcassets to filesystem to allow us to test getting images
    // from filesystem, as this is what we'll do for images retrieved from API.
    func loadInitImages() {
        if let items = getItems() {
            for item in items {
                if let image = getImageFromXcAssets(item: item), let fileName = getImageNameFromXcAssets(item: item) {
                    ImageManager.storeImage(image: image, with: fileName)
                }
            }
        }
    }
    
    // utility function to get the number of records for a given entity
    func printCount(entityName: String) {
        // test to see how many rows are in each entity
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let count = try context.count(for: request)
            print("\(entityName) rows: \(count)")
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
    
    func getImageFromXcAssets(item: Item) -> UIImage? {
        let request = Image.fetchRequest() as NSFetchRequest<Image>
        let predicate = NSPredicate(format: "item == %@", item)
        request.predicate = predicate
        
        if let image = try? context.fetch(request).first {
            return UIImage(named: "\(image.filename).png")
        }
        
        return nil
    }
    
    func getImageNameFromXcAssets(item: Item) -> String? {
        let request = Image.fetchRequest() as NSFetchRequest<Image>
        let predicate = NSPredicate(format: "item == %@", item)
        request.predicate = predicate
        
        if let image = try? context.fetch(request).first {
            return image.filename
        }
        
        return nil
    }
    
    func getImageFromFilesystem(item: Item) -> UIImage? {
        
        if let firstImage = item.images?.allObjects.first as? Image {
            let fileName = firstImage.filename
            print(ImageManager.getPath(for: fileName) ?? "no path found for \(firstImage.item.label ?? "unknown item")")
            return ImageManager.getImage(from: fileName)
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
