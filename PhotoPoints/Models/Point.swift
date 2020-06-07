//
//  Point.swift
//  PhotoPoints
//
//  Whereas Item is the primary object in the data model, it is a composition of several
//  different objects.  Point is the central object used by Item.  It contains the subset
//  of data used by the functions of the Item class itself, those required by any part of
//  the application using the Item.
//
//  Realm data fields
//  id:        this is the primary key for parent "Item"; -1 represents invalid or unwritten object
//  label:     a short string descriptor; used by the map or in lists where details are not accessed
//  location:  the coordinates of the Item
//  enabled:   boolean which determines if this point (and thus parent "Item" is returned in queries

import Foundation
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

// Convenience initializer(s) - allows fields to be set upon instantiation
extension Point {
    convenience init(id: Int, location: Coordinate, label: String?, enabled: Bool?) {
        self.init()
        
        // set primary key and location (required)
        self.id = id
        self.location = location
        
        // set label, or use app default if not provided
        self.label = label ?? UserDefaults.standard.string(forKey: "Label")

        // automatically enable unless otherwise specified
        self.enabled = enabled ?? true
    }
}



// functions to enable or disable this point (disables the parent item)
// not persistent until written to database
extension Point {
    func enable() {
        enabled = true
    }
    
    func disable() {
        enabled = false
    }
}
