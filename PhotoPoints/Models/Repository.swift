//
//  Repository.swift
//  PhotoPoints
//
//  Description:
//  An interface layer between the UI, the local database, and the API

import Foundation
import RealmSwift
import UIKit

class Repository {
    
    // MARK: - Definition / Init
    
    // Repository is a singleton, access using Repository.instance
    public static let instance = Repository()
    

    // create a queue for operations requiring thread safety
    private let serialQueue = DispatchQueue(label: "repoQueue")

    // instantiate the database. Creates a new one if none exists
    private let realm: Realm
    
    private init() {
        // instantiate the database, creating a new one if required
        let config = Realm.Configuration( deleteRealmIfMigrationNeeded: true )
        Realm.Configuration.defaultConfiguration = config
        self.realm = try! Realm()
    }
    
    
    func loadInitData() {
        // clear existing database data
        try! realm.write{ realm.deleteAll() }
        
        // build mock database
        MockDatabase.build()
        
        // write to realm
        try! realm.write {
            realm.add(MockDatabase.mockdb)
            realm.add(MockDatabase.qrLookups)
        }
    }

    // MARK: - Data Retrieval
    
    func getItems() -> Results<Item> {
        return realm.objects(Item.self)
    }
    
    func getImage(item: Item) -> UIImage? {
        if let id = item.id {
            if let results = realm.objects(Image.self).filter("id == '\(id)'").first {
                return UIImage(named: "\(results.filename).png")
            }
        }
        return nil
    }
    
    func getDetailValue(item: Item, property: String) -> String? {
        if let id = item.id {
            let detail = realm.objects(Detail.self).filter("id == '\(id)' AND property == '\(property)'").first
            return detail?.value
        }
        return nil
    }
    
    func getSearches() -> [String] {
        let lookups = realm.objects(Lookup.self)
        var searches = [String]()
        for lookup in lookups {
            searches.append(lookup.search)
        }
        return searches
    }
    
    func getItemFrom(search: String) -> Item? {
        if let id = realm.objects(Lookup.self).filter("search == '\(search)'").first?.id {
            if let item = realm.objects(Item.self).filter("id == '\(id)'").first {
                return item
            }
        }
        return nil
    }
    
}
