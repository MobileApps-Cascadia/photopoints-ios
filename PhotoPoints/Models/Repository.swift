//
//  Repository.swift
//  PhotoPoints
//
//  Created by Stephen Gomez-Fox on 5/9/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class Repository {
    
    // MARK: - Definition / Init
    
    // Repository is a singleton, access using Repository.instance
    public static let instance = Repository()
    
    private init() {}
    
    // create a queue for operations requiring thread safety
    private let serialQueue = DispatchQueue(label: "repoQueue")

    // instantiate the database. Creates a new one if none exists
    private let realm: Realm = try! Realm()
    
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
        if let image = realm.objects(Image.self).filter("id == \(item.id)").first {
            return UIImage(named: "\(image.fileName).png")
        }
        return nil
    }
    
    func getDetailValue(item: Item, property: String) -> String? {
        let detail = realm.objects(Detail.self).filter("id == \(item.id) AND property == '\(property)'").first
        return detail?.value
    }
    
    func getQrCodes() -> [String] {
        let qrLookups = realm.objects(QrLookup.self)
        var qrCodes = [String]()
        for qrLookup in qrLookups {
            qrCodes.append(qrLookup.qrCode)
        }
        return qrCodes
    }
    
    func getItemFromQrCode(qrCode: String) -> Item? {
        if let id = realm.objects(QrLookup.self).filter("qrCode == '\(qrCode)'").first?.id {
            if let item = realm.objects(Item.self).filter("id == \(id)").first {
                return item
            }
        }
        return nil
    }
    
}
