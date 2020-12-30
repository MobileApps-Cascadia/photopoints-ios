//
//  MapView.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 4/7/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import UIKit
import MapKit

// globally accessible instance
let mapVC = MapView()

class MapView: UIViewController {

    //MARK: - Properties
    
    let repository = Repository.instance
    
    // Creates new MKMapView for reference later
    var mapView: MKMapView!
    
    // Reuse ids for annotations
    let itemIdentifier = NSStringFromClass(ItemAnnotation.self)
    // Empty annotations array
    var annotations = [ItemAnnotation]()
    
    // Contains logic for setting and resetting currently displayed annotations.
    var displayedAnnotations: [ItemAnnotation]? {
        willSet {
            if let currentAnnotations = displayedAnnotations {
                mapView.removeAnnotations(currentAnnotations)
            }
        }
        didSet {
            if let newAnnotations = displayedAnnotations {
                mapView.addAnnotations(newAnnotations)
            }
            
        }
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMap()
        registerAnnotations()
        addOverlays()
    }
    
    //MARK: - Setup
    
    func setUpMap() {
        mapView = MKMapView(frame: view.frame)
        mapView.mapType = .standard
        
        // sets delegate
        mapView.delegate = self
        
        // bound map to forest
        mapView.region = .forest
        mapView.cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: .forest)
        mapView.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 30, maxCenterCoordinateDistance: 2500)
        
        // fill and add annotations
        fillAnnotations()
        mapView.addAnnotations(annotations)
        view.addSubview(mapView)
    }
    
    // Registers custom annotation views for use on the map, currently only contains one custom annotation type.
    func registerAnnotations(){
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: itemIdentifier)
    }
    
    func fillAnnotations() {
        let items = repository.getItems()!
        
        for item in items {
            if let location = item.location {
                let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                let annotation = ItemAnnotation(coordinate: coordinate)
                annotation.title = item.label
                annotations.append(annotation)
            }
        }
    }
    
    //Adds map annotations to aide the user when navigating the forest
    func addOverlays() {
        
        // forest boundary
        let boundaryGon = BoundaryGon(coordinates: boundary, count: boundary.count)
        mapView.addOverlay(boundaryGon)
        
        // streams
        for stream in streams {
            let streamLine = StreamLine(coordinates: stream, count: stream.count)
            mapView.addOverlay(streamLine)
        }
        
        // wetlands
        for wetLand in wetLands {
            let wetLandGon = WetLandGon(coordinates: wetLand, count: wetLand.count)
            mapView.addOverlay(wetLandGon)
        }
        
        // trails
        for trail in trails {
            let trailLine = TrailLine(coordinates: trail, count: trail.count)
            mapView.addOverlay(trailLine)
        }
        
    }
    
}

//MARK: - MKMapViewDelegate

extension MapView : MKMapViewDelegate {

    // Registers each annotationview added to the map depending on type
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: itemIdentifier)
        
        annotationView.clusteringIdentifier = "cluster"
        annotationView.collisionMode = .circle
        annotationView.canShowCallout = true
        
        // to be adjusted based on survey status
        annotationView.tintColor = .red
        
        let circleImage = UIImage(systemName: "circle.fill")!
        var borderImage: UIImage
        var fillImage: UIImage
        
        if annotation is MKClusterAnnotation {
            let count = (annotation as! MKClusterAnnotation).memberAnnotations.count
            let configuration = UIImage.SymbolConfiguration(font: fontSize(for: count))
            borderImage = circleImage.withConfiguration(configuration)
            fillImage = UIImage(systemName: "\(count).circle.fill", withConfiguration: configuration)!
        } else {
            let configuration = UIImage.SymbolConfiguration(font: fontSize(for: 1))
            borderImage = circleImage.withConfiguration(configuration)
            fillImage = borderImage
        }
        
        annotationView.image = borderImage
        annotationView.addSubview(UIImageView(image: fillImage))
        
        return annotationView
    }
    
    //extension for drawing annotations on map based on type
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is BoundaryGon {
            let polygonView = MKPolygonRenderer(overlay: overlay)
            polygonView.strokeColor = .gray
            polygonView.lineWidth = 3
            return polygonView
        }
        
        if overlay is WetLandGon {
            let wetLandView = MKPolygonRenderer(overlay: overlay)
            wetLandView.strokeColor = .systemBlue
            wetLandView.fillColor = .blue
            wetLandView.lineWidth = 3
            return wetLandView
        }
        
        if overlay is TrailLine {
            let trailLineView = MKPolylineRenderer(overlay: overlay)
            trailLineView.strokeColor = .brown
            trailLineView.lineWidth = 5
            trailLineView.lineDashPattern = [6]
            return trailLineView
        }
        
        if overlay is StreamLine {
            let streamLineView = MKPolylineRenderer(overlay: overlay)
            streamLineView.strokeColor = .systemBlue
            streamLineView.lineWidth = 3
            return streamLineView
        }
        
        return MKOverlayRenderer()
    }

}

//map maker font size
func fontSize(for count: Int) -> UIFont {
    let size = CGFloat(pow(Double(count), 1 / 3) * 25)
    return UIFont.systemFont(ofSize: size)
}

//MARK:- Static Constants

// add forestCenter as a static constant of the CLLocationCoordinate2D class
extension CLLocationCoordinate2D {

    static let forestCenter = CLLocationCoordinate2D(latitude: 47.778836, longitude: -122.194417)
    
}

// add forest as a static constant of the MKCoordinateRegion class
extension MKCoordinateRegion {
    
    static let forest = MKCoordinateRegion(center: .forestCenter, latitudinalMeters: 900, longitudinalMeters: 500)
    
}


  
    


