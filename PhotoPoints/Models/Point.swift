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
    var enabled: Bool
    
    init(id: Int, location: Coordinate, enabled: Bool) {
        self.id = id
        self.location = location
        self.enabled = enabled
    }
    
    func enable() {
        enabled = true
    }
    
    func disable() {
        enabled = false
    }

}
