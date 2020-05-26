//
//  Coordinate.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 5/6/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import Foundation
import CoreLocation
import Realm
import RealmSwift


class Coordinate: Object {
    
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var altitude: Double = 0.0
    
    convenience init(latitude: Double, longitude: Double, altitude: Double) {
        self.init()
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
    }
    
    let parent = LinkingObjects(fromType: Point.self, property: "location")
}

extension Coordinate {
    func twoDimensional() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
