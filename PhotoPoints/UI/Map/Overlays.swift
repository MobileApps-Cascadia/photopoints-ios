//
//  Overlays.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 3/11/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import MapKit

// overlay extensions to apply distinct formatting for each feature type
class BoundaryGon: MKPolygon, Renderable {
    func getRenderer() -> MKOverlayRenderer {
        let renderer = MKPolygonRenderer(overlay: self)
        renderer.strokeColor = .gray
        renderer.lineWidth = 3
        return renderer
    }
}

class WetlandGon: MKPolygon, Renderable {
    func getRenderer() -> MKOverlayRenderer {
        let renderer = MKPolygonRenderer(overlay: self)
        renderer.strokeColor = .systemBlue
        renderer.fillColor = .blue
        renderer.lineWidth = 3
        return renderer
    }
}

class StreamLine: MKPolyline, Renderable {
    func getRenderer() -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: self)
        renderer.strokeColor = .systemBlue
        renderer.lineWidth = 3
        return renderer
    }
}

class TrailLine: MKPolyline, Renderable {
    func getRenderer() -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: self)
        renderer.strokeColor = .brown
        renderer.lineWidth = 5
        renderer.lineDashPattern = [6]
        return renderer
    }
}
