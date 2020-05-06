//
//  Coordinate.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 5/6/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import Foundation
import CoreLocation

class Coordinate {
    
    var latitude: CLLocationDegrees {
        didSet {
            flat.latitude = latitude
        }
    }
    
    var longitude: CLLocationDegrees {
        didSet {
            flat.longitude = longitude
        }
    }
    
    var altitude: CLLocationDistance
    
    // current map annotations require a 2D coordinate
    var flat: CLLocationCoordinate2D
    
    init(latitude: CLLocationDegrees, longitude: CLLocationDegrees, altitude: CLLocationDistance){
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.flat = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
}
