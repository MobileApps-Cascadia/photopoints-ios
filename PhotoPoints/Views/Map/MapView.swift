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

class MapView: UIViewController {

private var allAnnotations: [CustomAnnotation]?


    let realm = try! Realm()
    let repository = Repository.instance
    
    // Creates new MKMapView for reference later
    var mapView : MKMapView!
    
    // instance variable so it can be referenced in didUpdateSurveyStatus() edit: I seem to have misplaced this comment at some point; not sure what this refers to - Grant
    
    // Empty annotations array
    var annotations = [CustomAnnotation]()
    
    
    // Contains logic for setting and resetting currently displayed annotations.
    var displayedAnnotations: [CustomAnnotation]? {
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
    
    // Registers custom annotation views for use on the map, currently only contains one custom annotation type.
    func registerAnnotations(){
        
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier:NSStringFromClass(CustomAnnotation.self))
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpMap()
        
        registerAnnotations()
        
        showAllAnnotations(self)
    }
    
       // Sets 'allAnnotations' to 'displayedAnnotations' in order to add them to the map
    private func showAllAnnotations(_ sender: Any) {
        displayedAnnotations = allAnnotations
    }
    
    func setUpMap() {
        mapView = MKMapView(frame: view.frame)
        mapView.mapType = .hybrid
        
        // sets delegate
        mapView.delegate = self
        
        // bound map to forest
        mapView.region = .forest
        mapView.cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: .forest)
        mapView.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 0, maxCenterCoordinateDistance: 200)
        
        // fill and add annotations
        fillAnnotations()
        mapView.addAnnotations(annotations)
        view.addSubview(mapView)
    }
    
    func fillAnnotations() {
        
        let items = realm.objects(Item.self)
        
        for item in items {
            if let location = item.point?.location {
                let annotation = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                annotation.title = repository.getDetailValue(item: item, property: "common_names")
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
    
    // Registers each annotationview added to the map depending on type. Currently only contains logic for 'simpleAnnotation' but can be expanded for other annotation types.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
          
        guard !annotation.isKind(of: MKUserLocation.self) else {
              // Make a fast exit if the annotation is the `MKUserLocation`, as it's not an annotation view we wish to customize.
            return nil
        }
          
        var annotationView: MKAnnotationView?
          
        if let annotation = annotation as? CustomAnnotation{ annotationView = setUpCustomAnnotationView(for: annotation, on: mapView)
            
        }
        
          return annotationView
      }
    
    // Sets up annotationViews for 'simpleAnnotation'
    private func setUpCustomAnnotationView(for annotation: CustomAnnotation, on mapView: MKMapView) -> MKAnnotationView{
        
        // Creates indentifiers for reusal in order to efficiently allocate resources
        let reuseIdentifier = NSStringFromClass(CustomAnnotation.self)
        let customAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier, for: annotation)
        
        // Enables callouts
        customAnnotationView.canShowCallout = true
        
        // Set map marker
        let image = #imageLiteral(resourceName: "marker-surveyed")
        customAnnotationView.image = image
        
        // Callout image. Likely wont keep this.
        customAnnotationView.leftCalloutAccessoryView = UIImageView(image: #imageLiteral(resourceName: "marker-surveyed"))
        
        return customAnnotationView
    }
    
}

// add forestCenter as a static constant of the CLLocationCoordinate2D class. Previous forest center lat:47.778836, long -122.194417. Adusted for purpose of zooming map to photopoints.
extension CLLocationCoordinate2D {

    static let forestCenter = CLLocationCoordinate2D(latitude: 47.774836, longitude: -122.191695)
    
}

// add forest as a static constant of the MKCoordinateRegion class
extension MKCoordinateRegion {
    
    static let forest = MKCoordinateRegion(center: .forestCenter, latitudinalMeters: 60, longitudinalMeters: 60)
    
}


  
    


