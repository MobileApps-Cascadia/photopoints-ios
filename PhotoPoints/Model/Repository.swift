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
    
    private init() {}
    
    // create a queue for operations requiring thread safety
    private let serialQueue = DispatchQueue(label: "repoQueue")
    
    // get managed context so we can save to core data persistent container
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // utility / debugging function to get the number of records for a given entity
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

    func saveContext() {
        if context.hasChanges {
            print("saving changes to context")
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Data Retrieval
    // Various get methods for different locations/objects
    func getItems() -> [Item]? {
        let request = Item.fetchRequest() as NSFetchRequest<Item>
        let sortDescriptor = NSSortDescriptor(key: "label", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        if let items = try? context.fetch(request) as [Item] {
            return items
        }
        
        return nil
    }
    
    func getImageFromXcAssets(item: Item) -> UIImage? {
        let request = Image.fetchRequest() as NSFetchRequest<Image>
        let predicate = NSPredicate(format: "item == %@", item)
        request.predicate = predicate
        
        if let image = try? context.fetch(request).first {
            return UIImage(named: "\(image.filename!).png")
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
            let fileName = firstImage.filename!
            return ImageManager.getImage(from: fileName, in: .images)
        }
        
        print("no path found for \(item.label ?? "unknown item")")
        return nil
    }
    
    func getDetails(for item: Item) -> [Detail] {
        let request = Detail.fetchRequest() as NSFetchRequest<Detail>
        let predicate = NSPredicate(format: "item == %@", item)
        let sortDescriptor = NSSortDescriptor(key: "property", ascending: false)
        request.predicate = predicate
        request.sortDescriptors = [sortDescriptor]
        
        if let details = try? context.fetch(request) as [Detail] {
            return details
        }
        
        return [Detail]()
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
    
    func getAllSubmissions(for item: Item) -> [Submission] {
        let request = Submission.fetchRequest() as NSFetchRequest<Submission>
        let predicate = NSPredicate(format: "item == %@", item)
        request.predicate = predicate
        
        if let submissions = try? context.fetch(request) as [Submission] {
            return submissions
        }
        
        return [Submission]()
    }
    
    func getTodaysSubmissions(for item: Item) -> [Submission] {
        let start = Date.start as CVarArg
        let end = Date.end as CVarArg
        
        let request = Submission.fetchRequest() as NSFetchRequest<Submission>
        let predicate = NSPredicate(format: "item == %@ AND (date >= %@ AND date < %@)", item, start, end)
        request.predicate = predicate
        
        if let submissions = try? context.fetch(request) {
            return submissions
        }
        
        return [Submission]()
    }
    
    func didSubmitToday(for item: Item) -> Bool {
        return (getTodaysSubmissions(for: item).count > 0)
    }
    
    func getAllUserPhotos(for item: Item) -> [UserPhoto] {
        let request = UserPhoto.fetchRequest() as NSFetchRequest<UserPhoto>
        let predicate = NSPredicate(format: "submission.item == %@", item)
        request.predicate = predicate
        
        if let photos = try? context.fetch(request) {
            return photos
        }
        
        return [UserPhoto]()
    }
    
    func getTodaysUserPhotos(for item: Item) -> [UserPhoto] {
        let start = Date.start as CVarArg
        let end = Date.end as CVarArg
        let request = UserPhoto.fetchRequest() as NSFetchRequest<UserPhoto>
        let predicate = NSPredicate(format: "submission.item == %@ AND (submission.date >= %@ AND submission.date < %@)", item, start, end)
        request.predicate = predicate
        
        if let photos = try? context.fetch(request) {
            return photos
        }
        
        return [UserPhoto]()
    }
    
    func getItemsWithSubmissionsToday() -> [Item] {
        var itemsWithSubmissionsToday = [Item]()
        if let items = getItems() {
            for item in items {
                if didSubmitToday(for: item) {
                    itemsWithSubmissionsToday.append(item)
                }
            }
        }
        return itemsWithSubmissionsToday
    }
}

extension Date {
    static let start = Calendar.current.startOfDay(for: Date())
    static let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!
}
