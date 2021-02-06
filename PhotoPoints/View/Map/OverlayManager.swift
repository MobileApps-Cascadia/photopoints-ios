//
//  OverlayManager.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 2/5/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import MapKit

class OverlayManager {
    
    lazy var renderers = [
        NSStringFromClass(BoundaryGon.self) : boundaryRenderer,
        NSStringFromClass(WetlandGon.self) : wetlandRenderer,
        NSStringFromClass(StreamLine.self) : streamRenderer,
        NSStringFromClass(TrailLine.self) : trailRenderer,
    ]
    
    let boundaryRenderer: MKPolygonRenderer = {
        let renderer = MKPolygonRenderer()
        renderer.strokeColor = .gray
        renderer.lineWidth = 3
        return renderer
    }()
    
    let wetlandRenderer: MKPolygonRenderer = {
        let renderer = MKPolygonRenderer()
        renderer.strokeColor = .systemBlue
        renderer.fillColor = .blue
        renderer.lineWidth = 3
        return renderer
    }()
    
    let trailRenderer: MKPolylineRenderer = {
        let renderer = MKPolylineRenderer()
        renderer.strokeColor = .brown
        renderer.lineWidth = 5
        renderer.lineDashPattern = [6]
        return renderer
    }()
    
    let streamRenderer: MKPolylineRenderer = {
        let renderer = MKPolylineRenderer()
        renderer.strokeColor = .systemBlue
        renderer.lineWidth = 3
        return renderer
    }()
    
    //Adds map annotations to aide the user when navigating the forest
    func addOverlays(to mapView: MKMapView) {
        
        // forest boundary
        let boundaryGon = BoundaryGon(coordinates: Boundary.boundary, count: Boundary.boundary.count)
        mapView.addOverlay(boundaryGon)
        
        // streams
        for stream in Streams.streams {
            let streamLine = StreamLine(coordinates: stream, count: stream.count)
            mapView.addOverlay(streamLine)
        }
        
        // wetlands
        for wetland in Wetlands.wetlands {
            let wetLandGon = WetlandGon(coordinates: wetland, count: wetland.count)
            mapView.addOverlay(wetLandGon)
        }
        
        // trails
        for trail in Trails.trails {
            let trailLine = TrailLine(coordinates: trail, count: trail.count)
            mapView.addOverlay(trailLine)
        }
    }
    
}
