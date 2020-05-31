//
//  QrLookup.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 5/13/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class QrLookup: Object {
    @objc dynamic var id: Int = -1
    @objc dynamic var qrCode: String = ""
    
    required init() {}
    
    required init(id: Int, qrCode: String) {
        self.id = id
        self.qrCode = qrCode
    }
}
