//
//  Point.swift
//  PhotoPoints
//
//  Description:
//  Whereas Item is the primary object in the data model, it is a composition of several
//  different objects.  Point is the central object used by Item.  It contains the subset
//  of data used by the functions of the Item class itself, those required by any part of
//  the application using the Item.

import Foundation
import Realm
import RealmSwift

class Point: Object {
    
    // Realm object fields
    @objc dynamic var id = -1
    @objc dynamic var label: String? = nil
    @objc dynamic var location: Coordinate? = nil
    @objc dynamic var enabled: Bool = false
    
    // establishes "id" as primary key for this point (and its parent "Item")
    // should never be modified once written to database
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // establishes parent object relationship
    let parent = LinkingObjects(fromType: Item.self, property: "point")

}

// Standard initializer - use this during normal instantiation
extension Point {
    convenience init(id: Int, location: Coordinate, label: String, enabled: Bool) {
        self.init()
        self.id = id
        self.label = label
        self.location = location
        self.enabled = enabled
    }
}

// enable or disable this point (disables the item)
extension Point {
    func enable() {
        enabled = true
    }
    
    func disable() {
        enabled = false
    }
}
