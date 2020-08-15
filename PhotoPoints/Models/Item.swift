//
//  PointItem.swift
//  PhotoPoints
//
//  Description:
//  Item is the fundamental data object of the application.  It is a composition of several
//  other Realm Object classes and the primary means with which the underlying Object classes
//  are created and modified.  Generally, its properties are accessed using a string subscript.
//
//  Realm data fields:
//  id:        The id of the item.  This is the primary key which associates item with other objects
//  point:     The item's fundamental properties
//  details:   List of key/value properties associated with the item, stored as strings
//  images:    List of records for selecting and accessing image files related to the item

import Foundation

class Item {
    
    // Realm data fields
    var id: String? = nil
    var point: Point? = nil
    let details = List<Detail>()
    let images = List<Image>()

}

// Convenience initializer(s) - allows fields to be set upon instantiation

extension Item {
    
    convenience init(id: String, point: Point, details: [String: String] = [:], images: [Image] = []) {
        self.init()
        self.id = id
        point.id = id
        self.point = point
        for (key, value) in details {
            let detail = Detail(id: id, property: key, value: value)
            self.details.append(detail)
        }
        for image in images {
            image.id = id
            self.images.append(image)
        }
    }
    
}

