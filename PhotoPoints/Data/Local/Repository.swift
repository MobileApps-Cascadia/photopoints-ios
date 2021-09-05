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
    
    // Repository is a singleton, access using Repository.instance
    public static let instance = Repository()
    
    private init() {}
    
    var items = [Item]()
    
    var imageCache = [String: Data]()
    
    // MARK: - Items
    var itemsWithSubmissionsToday: [Item] {
        return items.filter { didSubmitToday(for: $0) }
    }
    
    func getItem(from url: String) -> Item? {
        return items.first { $0.url == url }
    }
    
    func getItem(with id: String) -> Item? {
        return items.first { $0.id == id }
    }
    
    // MARK: - Images
    func getUIImageFromXcAssets(item: Item) -> UIImage? {
        if let image = item.images.first {
            return UIImage(named: "\(image.filename).png")
        }
        
        return nil
    }
    
    func getImageName(item: Item) -> String? {
        if let image = item.images.first {
            return image.filename
        }
        
        return nil
    }
    
    func getUIImageFromFilesystem(item: Item) -> UIImage? {
        if  let firstImage = getFirstImage(of: item) {
            let fileName = firstImage.filename
            return ImageManager.getImage(from: fileName, in: .images)
        }
        
        print("no path found for \(item.label)")
        return nil
    }
    
    func getFirstImage(of item: Item) -> Image? {
        return item.images.first
    }

    // MARK: - Submissions
    func getAllSubmissions(for item: Item) -> [Submission] {
        let request = Submission.fetchRequest() as NSFetchRequest<Submission>
        let predicate = NSPredicate(format: "itemID == %@", item.id)
        request.predicate = predicate
        
        if let submissions = try? context.fetch(request) as [Submission] {
            return submissions
        } else {
            return []
        }
    }
    
    func getTodaysSubmissions(for item: Item) -> [Submission] {
        let start = Date.start as CVarArg
        let end = Date.end as CVarArg
        
        let request = Submission.fetchRequest() as NSFetchRequest<Submission>
        let predicate = NSPredicate(format: "itemID == %@ AND (date >= %@ AND date < %@)", item.id, start, end)
        request.predicate = predicate
        
        if let submissions = try? context.fetch(request) {
            return submissions
        } else {
            return []
        }
    }
    
    func didSubmitToday(for item: Item) -> Bool {
        return (getTodaysSubmissions(for: item).count > 0)
    }
    
    func getTodaysUserPhotos(for item: Item) -> [UserPhoto] {
        let start = Date.start as CVarArg
        let end = Date.end as CVarArg
        let request = UserPhoto.fetchRequest() as NSFetchRequest<UserPhoto>
        let predicate = NSPredicate(format: "submission.itemID == %@ AND (submission.date >= %@ AND submission.date < %@)", item.id, start, end)
        request.predicate = predicate
        
        if let photos = try? context.fetch(request) {
            return photos
        } else {
            return []
        }
    }
    
}

// MARK: - Core Data
extension Repository {

    var persistentContainer: NSPersistentContainer {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "PhotoPoints")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
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
    
}
