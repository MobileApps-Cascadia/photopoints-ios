//
//  Coordinate.swift
//  PhotoPoints
//
//  Description:
//  The coordinates location contains the location of an "Item" in as geocoordinates.  It
//  is a required child object of a "Point"
//
//  Realm data fields:
//  latitude:  The latitude (north/south) coordinate
//  longitude: The longitude (east/west) coordinate
//  altitude:  The altitude above sea level; defaults to zero if unused


import Foundation
import CoreLocation
import RealmSwift


class Coordinate: Object {
    
    // Realm object fields
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var altitude: Double = 0.0
    
    // establishes parent object relationship
    let parent = LinkingObjects(fromType: Point.self, property: "location")
    
}


// add initializer(s) to set initial data at instantiation
extension Coordinate {
    
    convenience init(latitude: Double, longitude: Double, altitude: Double = 0) {
        self.init()
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
    }
    
}


// provides CoreLocation coordinate for iOS maps api
extension Coordinate {
    
    func twoDimensional() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
}
