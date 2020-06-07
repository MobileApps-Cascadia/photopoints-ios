//
//  Detail.swift
//  PhotoPoints
//
//  Created by Stephen Gomez-Fox on 5/25/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Detail: Object {
    @objc dynamic var id: Int = -1
    @objc dynamic var property: String = ""
    @objc dynamic var value: String = ""
}

// Convenience initializer(s) - allows fields to be set upon instantiation
extension Detail {
    convenience init(id: Int, property: String, value: String?) {
        self.init()
        if property.count > 0 {
            self.id = id
            self.property = property
            if let val=value {self.value = val}
        }
    }
}
