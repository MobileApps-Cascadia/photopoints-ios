//
//  OverlayManager.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 2/5/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import MapKit

class OverlayManager {
    
    // adds different types of overlays to map
    static func addOverlays(to mapView: MKMapView) {
        
        for boundary in OverlayData.boundary {
            let boundaryGon = BoundaryGon(coordinates: boundary, count: boundary.count)
            mapView.addOverlay(boundaryGon)
        }
        
        for stream in OverlayData.streams {
            let streamLine = StreamLine(coordinates: stream, count: stream.count)
            mapView.addOverlay(streamLine)
        }
        
        for wetland in OverlayData.wetlands {
            let wetLandGon = WetlandGon(coordinates: wetland, count: wetland.count)
            mapView.addOverlay(wetLandGon)
        }
        
        for trail in OverlayData.trails {
            let trailLine = TrailLine(coordinates: trail, count: trail.count)
            mapView.addOverlay(trailLine)
        }
    }
    
}
