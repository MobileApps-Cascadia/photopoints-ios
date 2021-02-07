//
//  OverlayManager.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 2/5/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import MapKit

// overlay extensions to apply distinct formatting for each feature type
class BoundaryGon: MKPolygon {}
class WetlandGon: MKPolygon {}
class StreamLine: MKPolyline {}
class TrailLine: MKPolyline {}

// renderer subclasses applying distinct formatting
class BoundaryRenderer: MKPolygonRenderer {
    override init(overlay: MKOverlay) {
        super.init(overlay: overlay)
        strokeColor = .gray
        lineWidth = 3
    }
}

class WetlandRenderer: MKPolygonRenderer {
    override init(overlay: MKOverlay) {
        super.init(overlay: overlay)
        strokeColor = .systemBlue
        fillColor = .blue
        lineWidth = 3
    }
}

class TrailRenderer: MKPolylineRenderer {
    override init(overlay: MKOverlay) {
        super.init(overlay: overlay)
        strokeColor = .brown
        lineWidth = 5
        lineDashPattern = [6]
    }
}

class StreamRenderer: MKPolylineRenderer {
    override init(overlay: MKOverlay) {
        super.init(overlay: overlay)
        strokeColor = .systemBlue
        lineWidth = 3
    }
}

class OverlayManager {

    // dictionary to look up appropriate renderer for given overlay type
    static var renderers = [
        NSStringFromClass(BoundaryGon.self) : BoundaryRenderer.self,
        NSStringFromClass(WetlandGon.self) : WetlandRenderer.self,
        NSStringFromClass(StreamLine.self) : StreamRenderer.self,
        NSStringFromClass(TrailLine.self) : TrailRenderer.self,
    ]
    
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
