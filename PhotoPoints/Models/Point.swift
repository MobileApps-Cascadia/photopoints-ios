//
//  Point.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 5/6/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import Foundation

class Point {
    
    let id: Int
    let location: Coordinate
    let type: PointItemType
    var enabled: Bool
    
    init(id: Int, location: Coordinate, type: PointItemType, enabled: Bool) {
        self.id = id
        self.location = location
        self.type = type
        self.enabled = enabled
    }
    
    func enable() {
        enabled = true
    }
    
    func disable() {
        enabled = false
    }

}
