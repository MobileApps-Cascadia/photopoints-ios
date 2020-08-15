//
//  Detail.swift
//  PhotoPoints
//
//  Whereas Item is the primary object in the data model, it is a composition of several
//  different objects.  Detail objects are part of a list of details about an Item.  Each
//  Detail is a KVP and regardless of its type of usage, all Detail are stored internally
//  using a string key ("property") and an optional string "value"
//
//  Realm data fields
//  id:        this is the primary key matching tha of "Item"; -1 represents invalid or unwritten object
//  property:  the key in the key/value pair
//  value:     the value in the key value pair


import Foundation

class Detail {
    
    // object fields
    var id: String? = nil               // must be set to be valid
    var property: String? = nil         // must be set to be valid
    var value: String? = nil
    
    // establishes parent object relationship
    let parent = LinkingObjects(fromType: Item.self, property: "details")
    
}

// Convenience initializer(s) - allows fields to be set upon instantiation
extension Detail {
    
    // create a property from any type, converting to string. Default id is -1
    convenience init(id: String? = nil, property: String, value: Any?) {
        self.init()
        // ignores all if property is an empty string
        if property.count > 0 {
            if let providedId = id { self.id = providedId }
            if property.count > 0 {
                self.property = property
                self.value = value as? String
            }
        }
    }
    
}





