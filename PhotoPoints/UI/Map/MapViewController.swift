//
//  MapViewController.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 4/7/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    //MARK: - Properties
    
    let repository = Repository.instance
    
    // Empty annotations array
    var annotations = [ItemAnnotation]()
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.region = .fitted
            mapView.cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: .forest)
            mapView.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 30, maxCenterCoordinateDistance: 2500)
        }
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillAnnotations()
        OverlayManager.addOverlays(to: mapView)
        view.addSubview(mapView)
        navigationController?.navigationBar.topItem?.title = "North Creek Forest"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // refresh annotations each time we switch back to this view
        // so we can update their color if they were surveyed
        mapView.removeAnnotations(annotations)
        mapView.addAnnotations(annotations)
    }
    
    //MARK: - Setup
    
    func fillAnnotations() {
        let items = repository.getItems()
        
        for item in items {
            let annotation = ItemAnnotation(item: item)
            annotations.append(annotation)
        }
    }

}

//MARK: - MKMapViewDelegate

extension MapViewController : MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return ItemAnnotationView(annotation: annotation)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay = overlay as? Renderable {
            return overlay.getRenderer()
        }
        
        fatalError("overlay \(type(of: overlay)) does not conform to Renderable")
    }

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
