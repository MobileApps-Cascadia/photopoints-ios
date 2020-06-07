//
//  QrLookup.swift
//  PhotoPoints
//
//  Description:
//  Provides a way to look up items by using a code, such as a QR code, a barcode,
//  or some other string identifier
//
//  Realm data fields:
//  qrCode:   The lookup string
//  id:       The integer id of the associated item


import Foundation
import RealmSwift

class QrLookup: Object {
    
    // Realm object fields
    @objc dynamic var id: Int = -1                // must be set to be valid
    @objc dynamic var qrCode: String? = nil       // must be set to be valid

}

// add initializer(s) to set initial data at instantiation
extension QrLookup {
    convenience init(qrCode: String, id: Int) {
        self.init()
        if id >= 0 { self.id = id } else { self.id = -1 }
        self.qrCode = qrCode
    }
}
