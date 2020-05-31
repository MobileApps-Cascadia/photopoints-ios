//
//  MapView.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 4/7/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import UIKit
import MapKit
import Realm
import RealmSwift

// fake singleton
let mapVC = MapView()

class MapView: UIViewController, MKMapViewDelegate {

    let realm = try! Realm()
    let repository = Repository.instance
    
    // empty annotations array
    // instance variable so it can be referenced in didUpdateSurveyStatus()
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMap()
    }
    
    func setUpMap() {
        let mapView = MKMapView(frame: view.frame)
        mapView.mapType = .hybrid
        
        // bound map to forest
        mapView.region = .forest
        mapView.cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: .forest)
        mapView.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 0, maxCenterCoordinateDistance: 2500)
        
        // fill and add annotations
        fillAnnotations()
        mapView.addAnnotations(annotations)
        view.addSubview(mapView)
    }

    func fillAnnotations() {
        
        let items = realm.objects(Item.self)
        
        for item in items {
            if let location = item.point?.location {
                let annotation = MKPointAnnotation()
                annotation.title = repository.getDetailValue(item: item, property: "common_names")
                annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                annotations.append(annotation)
            }
        }

    }
    
    // called in scannerView when we "survey" a plant
    // surveyStatus has already been updated, but we want to reflect this on the map
    
    // TODO: figure out how to update survey status in map with new model
    
//    func didUpdateSurveyStatus(commonName: String) {
//
//        // find the first annotation matching the commonName string passed in
//        let thisAnnotation = annotations.first(where: { (annotation) -> Bool in
//            return annotation.title == commonName
//        })
//
//        thisAnnotation?.subtitle = SurveyStatus.surveyed.rawValue
//    }
    
}

// add forestCenter as a static constant of the CLLocationCoordinate2D class
extension CLLocationCoordinate2D {

    static let forestCenter = CLLocationCoordinate2D(latitude: 47.778836, longitude: -122.194417)
    
}

// add forest as a static constant of the MKCoordinateRegion class
extension MKCoordinateRegion {
    
    static let forest = MKCoordinateRegion(center: .forestCenter, latitudinalMeters: 1200, longitudinalMeters: 500)
    
}
