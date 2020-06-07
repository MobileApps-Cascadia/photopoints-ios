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
//  id:       The id of the associated item


import Foundation
import RealmSwift

class QrLookup: Object {
    @objc dynamic var id: Int = -1                // must be set to be valid
    @objc dynamic var qrCode: String = "error"    // must be set to be valid
    
}

extension QrLookup {
    convenience init(id: Int, qrCode: String) {
        self.init()
        self.id = id
        self.qrCode = qrCode
    }
}
