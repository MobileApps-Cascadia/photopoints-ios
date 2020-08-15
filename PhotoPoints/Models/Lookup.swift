//
//  QrLookup.swift
//  PhotoPoints
//
//  Description:
//  Provides a way to look up items using a String, such as a QR code, a barcode,
//  or some other string identifier.  A nil id marks a search
//
//  Realm data fields:
//  search:   The lookup string, a QR Code, barcode, or associated unique lookup string
//  id:       The integer id of the associated item


import Foundation

class Lookup {
    
    // Realm object fields
    var search: String = ""                     // must be set to be valid
    var id: String?                             // must be set to be valid

    // establish primary key for this object
    override static func primaryKey() -> String? {
        return "search"
    }
    
}

// add initializer(s) to set initial data at instantiation
extension Lookup {
    
    convenience init(search: String, id: String?) {
        self.init()
        self.search = search
        self.id = id
    }
    
}
