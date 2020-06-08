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
        try! realm.write {
            realm.deleteAll()
            realm.add(MockDatabase.items)
            realm.add(MockDatabase.qrlookups)
        }
    }

    // MARK: - Data Retrieval
    
    func getItems() -> Results<Item> {
        return realm.objects(Item.self)
    }
    
    func getImage(item: Item) -> UIImage? {
        if let image = realm.objects(Image.self).filter("id == \(String(describing: item.id))").first {
            return UIImage(named: "\(String(describing: image.fileName)).png")
        }
        return nil
    }
    
    func getDetailValue(item: Item, property: String) -> String? {
        let detail = realm.objects(Detail.self).filter("id == \(String(describing: item.id)) AND property == '\(property)'").first
        return detail?.value
    }
    
    func getQrCodes() -> [String] {
        let qrLookups = realm.objects(Lookup.self)
        var qrCodes: [String] = [String]()
        for qrLookup in qrLookups {
            qrCodes.append(qrLookup.search )
        }
        return qrCodes
    }
    
    func getItemFromQrCode(qrCode: String) -> Item? {
        if let id = realm.objects(Lookup.self).filter("qrCode == '\(qrCode)'").first?.id {
            if let item = realm.objects(Item.self).filter("id == \(id)").first {
                return item
            }
        }
        return nil
    }
    
}
