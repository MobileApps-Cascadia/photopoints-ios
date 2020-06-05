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

class MapView: UIViewController {

private var allAnnotations: [MKAnnotation]?


    let realm = try! Realm()
    let repository = Repository.instance
    
    var mapView : MKMapView!
    
    // empty annotations array
    // instance variable so it can be referenced in didUpdateSurveyStatus()
    var annotations = [MKPointAnnotation]()
    
    
    
    var displayedAnnotations: [MKAnnotation]? {
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
    
    func registerAnnotations(){
        
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier:NSStringFromClass(SimpleAnnotation.self))
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpMap()
        
        registerAnnotations()
        
        allAnnotations = [SimpleAnnotation()]
        
         
        
        showAllAnnotations(self)
    }
    
    private func showAllAnnotations(_ sender: Any) {
        displayedAnnotations = allAnnotations
    }
    
    func setUpMap() {
        mapView = MKMapView(frame: view.frame)
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
extension MapView: MKMapViewDelegate {
    

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
          
        guard !annotation.isKind(of: MKUserLocation.self) else {
              // Make a fast exit if the annotation is the `MKUserLocation`, as it's not an annotation view we wish to customize.
            return nil
        }
          
        var annotationView: MKAnnotationView?
          
        if let annotation = annotation as? SimpleAnnotation{ annotationView = setUpSimpleAnnotationView(for: annotation, on: mapView)
            
        }
        
          return annotationView
      }
    
    private func setUpSimpleAnnotationView(for annotation: SimpleAnnotation, on mapView: MKMapView) -> MKAnnotationView{
        
        let reuseIdentifier = NSStringFromClass(SimpleAnnotation.self)
        let simpleAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier, for: annotation)
        
        simpleAnnotationView.canShowCallout = true
        
        let image = #imageLiteral(resourceName: "flag-1")
        simpleAnnotationView.image = image
        
        simpleAnnotationView.leftCalloutAccessoryView = UIImageView(image: #imageLiteral(resourceName: "flag"))
        
        return simpleAnnotationView
    }
    
}

// add forestCenter as a static constant of the CLLocationCoordinate2D class
extension CLLocationCoordinate2D {

    static let forestCenter = CLLocationCoordinate2D(latitude: 47.778836, longitude: -122.194417)
    
}

// add forest as a static constant of the MKCoordinateRegion class
extension MKCoordinateRegion {
    
    static let forest = MKCoordinateRegion(center: .forestCenter, latitudinalMeters: 1200, longitudinalMeters: 500)
    
}

    
  
    


