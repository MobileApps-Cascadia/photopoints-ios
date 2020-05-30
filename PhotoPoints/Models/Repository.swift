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
    
    func getItemFromQrCode(qrCode: String) -> Item? {
        if let id = realm.objects(QrLookup.self).filter("qrCode == '\(qrCode)'").first {
            if let item = realm.objects(Item.self).filter("id == \(id)").first {
                return item
            }
        }
        return nil
    }
    
    func printContents() {
        
    }
    
    // MARK: - TESTS

    // TODO:  REMOVE TEST CODE
    // Repository Realm Test - A read/write test of Realm Database
    // returns true of write, read, and delete of a test object succeeds
    func testDB() -> Bool {

        let results: String = "REPOSITORY REALM TEST:"
        var success = true     // becomes false if any of the checks don't work

        do {
            let str = "TESTING"
            let t = RealmTest()
            
            t.test = str
            try realm.write {
                realm.add(t)
            }
            var obj = realm.objects(RealmTest.self)
            if obj.count == 0 {
                success = false
            } else {
                if obj[0].test != str {success = false}
            }
            try realm.write{
                realm.delete(obj)
            }
            obj = realm.objects(RealmTest.self)
            if obj.count != 0 {success = false}
        } catch {success = false}
        print(results + (success ? "SUCCESS" : "FAIL"))
        return success
    }
    
    
    // TODO:  REMOVE TEST CODE
    // Repository Thread Safe Test - An example of thread safe repository operation
    // returns true if serialQueue sync operation completes
    func testSync() -> Bool {
        let results: String = "REPOSITORY THREAD SAFE TEST: "
        var success = false
        serialQueue.sync {
            success = true
        }
        print(results + (success ? "SUCCESS" : "FAIL"))
        return success
    }
    

    // TODO:  REMOVE TEST CODE
    // Repository default test - always succeeds if repository instance exists
    func test() -> Bool {
        print("REPOSITORY DEFAULT TEST: SUCCESS")
        return true
    }
}

// TODO:  REMOVE TEST CODE
// Test class for Realm Database
class RealmTest:Object {
    @objc dynamic var test:String?
}
