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
    let clusterIdentifier = NSStringFromClass(ClusterAnnotation.self)
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
        mapView.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 50, maxCenterCoordinateDistance: 2500)
        
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
    
}

//MARK: - MKMapViewDelegate

extension MapView : MKMapViewDelegate {

    // Registers each annotationview added to the map depending on type
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // Make a fast exit if the annotation is the `MKUserLocation`, as it's not an annotation view we wish to customize
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        
        guard let annotation = annotation as? ItemAnnotation else { return nil }
        
        let annotationView = setUpCustomAnnotationView(for: annotation, on: mapView)
        
        return annotationView
    }
    
    // Sets up annotationViews for ItemAnnotation
    private func setUpCustomAnnotationView(for annotation: ItemAnnotation, on mapView: MKMapView) -> MKAnnotationView {
        let itemAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: itemIdentifier, for: annotation)
        
        // Enables callouts
        itemAnnotationView.canShowCallout = true
        
        // Set map marker
        itemAnnotationView.image = UIImage(named: "item-marker-unsurveyed")
        
        return itemAnnotationView
    }
    
//    func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
//        let clusterAnnotationView = mapView.
//        
//        
//    }

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


  
    


