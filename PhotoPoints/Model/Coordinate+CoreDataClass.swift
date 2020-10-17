//
//  Coordinate+CoreDataClass.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 8/18/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//
//

import UIKit
import CoreData
import MapKit

@objc(Coordinate)
public class Coordinate: NSManagedObject {

    convenience init(latitude: Double, longitude: Double) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        self.init(entity: Coordinate.entity(), insertInto: context)
        
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = 0
    }
    
    func twoDimensional() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
}
