//
//  RegionFitted.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 2/5/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import MapKit

extension MKCoordinateRegion {
    
    // min and max lat and long for initial camera frame
    private static var minLat: CLLocationDegrees!
    private static var maxLat: CLLocationDegrees!
    private static var minLong: CLLocationDegrees!
    private static var maxLong: CLLocationDegrees!
    
    // buffer zone around coordinates
    private static let buffer = 0.0001
    
    // purpose of this extension is to return region fitted to item set
    static var fitted: MKCoordinateRegion = {
        updateMinMax()
        return fitToItems()
    }()
    
    private static func updateMinMax() {
        Repository.instance.getItems().forEach { item in
            updateMinMax(location: item.location!)
        }
    }
    
    private static func updateMinMax(location: Coordinate) {
        let lat = location.latitude
        let long = location.longitude
       
        if minLat == nil || lat < minLat {
            minLat = lat
        }
        
        if minLong == nil || long < minLong {
            minLong = long
        }
        
        if maxLat == nil || lat > maxLat {
            maxLat = lat
        }
        
        if maxLong == nil || long > maxLong {
            maxLong = long
        }
    }
    
    private static func fitToItems() -> MKCoordinateRegion {
        let midlat = (minLat + maxLat) / 2
        let midLong = (minLong + maxLong) / 2
        
        let latDelta = maxLat - minLat + buffer
        let longDelta = maxLong - minLong + buffer
        
        let center = CLLocationCoordinate2D(latitude: midlat, longitude: midLong)
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        
        return MKCoordinateRegion(center: center, span: span)
    }
}
