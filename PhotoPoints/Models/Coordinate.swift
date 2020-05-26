//
//  Coordinate.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 5/6/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import Foundation
import CoreLocation

@objcMembers class Coordinate {
    
    dynamic var latitude: CLLocationDegrees
    dynamic var longitude: CLLocationDegrees
    dynamic var altitude: CLLocationDistance
    
    init(latitude: CLLocationDegrees, longitude: CLLocationDegrees, altitude: CLLocationDistance) {
        // in na all long neg, all lat pos
        if latitude < 0 || longitude > 0 {
            self.latitude = longitude
            self.longitude = latitude
        } else {
            self.latitude = latitude
            self.longitude = longitude
        }
        
        self.altitude = altitude
    }
    
    func twoDimensional() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
}
