//
//  MapView.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 4/7/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import UIKit
import MapKit

// fake singleton
let mapVC = MapView()


private var allAnnotations: [MKAnnotation]?

class MapView: UIViewController {

    var mapView = MKMapView()
    
    // empty annotations array
    // instance variable so it can be referenced in didUpdateSurveyStatus()
    var annotations = [MKPointAnnotation]()
    
    private var allAnnotations: [MKAnnotation]?
    
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
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier:("SimpleAnnotation"))
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpMap()
        
        registerAnnotations()
        
        allAnnotations = [SimpleAnnotation()]
        
        
        
         
        
        showAllAnnotations(self)
    }
    
    private func showAllAnnotations(_ sender: Any) {
        // User tapped "All" button in the bottom toolbar
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
        //mapView.addAnnotations(allAnnotations!)
        view.addSubview(mapView)
    }
    
    func fillAnnotations() {
        
        let plants = MockDatabase.plants

        for plant in plants {
            let annotation = MKPointAnnotation()
            annotation.title = plant.commonName
            annotation.subtitle = plant.surveyStatus.rawValue
            annotation.coordinate = plant.coords
            annotations.append(annotation)
        }
    }
    
    // called in scannerView when we "survey" a plant
    // surveyStatus has already been updated, but we want to reflect this on the map
    func didUpdateSurveyStatus(commonName: String) {
        
        // find the first annotation matching the commonName string passed in
        let thisAnnotation = annotations.first(where: { (annotation) -> Bool in
            return annotation.title == commonName
        })
        
        thisAnnotation?.subtitle = SurveyStatus.surveyed.rawValue
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
          
          guard !annotation.isKind(of: MKUserLocation.self) else {
              // Make a fast exit if the annotation is the `MKUserLocation`, as it's not an annotation view we wish to customize.
              return nil
          }
          
          
          
          let reuseIdentifier = "SimpleAnnotation"
          let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
          annotationView.image = UIImage(named: "flag")
          annotationView.canShowCallout = true
          /*if let annotation = annotation as? SimpleAnnotation {
              annotationView = setupSimpleAnnotationView(for: annotation, on: mapView)
          }*/
          
          return annotationView
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

    
  
    


