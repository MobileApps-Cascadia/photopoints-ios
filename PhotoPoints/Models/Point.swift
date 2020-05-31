//
//  Point.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 5/6/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Point: Object {

    @objc dynamic var id = -1
    @objc dynamic var location: Coordinate? = nil
    @objc dynamic var enabled: Bool = false
    
    convenience init(id: Int, location: Coordinate, label: String, enabled: Bool) {
        self.init()
        self.id = id
        //self.label = label      TODO:  CLEAR REALM ON RUN TO ALLOW MODEL CHANGE
        self.location = location
        self.enabled = enabled
    }
    
    let parent = LinkingObjects(fromType: Item.self, property: "point")

    override static func primaryKey() -> String? {
        return "id"
    }
}

extension Point {
    func enable() {
        enabled = true
    }
    
    func disable() {
        enabled = false
    }
}
