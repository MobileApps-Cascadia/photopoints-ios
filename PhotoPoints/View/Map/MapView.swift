//
//  MapView.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 4/7/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import UIKit
import MapKit

class MapView: UIViewController {

    //MARK: - Properties
    
    let repository = Repository.instance
    
    // Empty annotations array
    var annotations = [ItemAnnotation]()
    
    let overlayManager = OverlayManager()
    
    lazy var mapView = MKMapView(frame: view.frame)
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillAnnotations()
        setUpMap()
        overlayManager.addOverlays(to: mapView)
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
        let items = repository.getItems()!
        for item in items {
            let annotation = ItemAnnotation(item: item)
            annotations.append(annotation)
        }
    }
    
    func setUpMap() {
        mapView.delegate = self
        mapView.region = .fitted
        mapView.cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: .forest)
        mapView.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 30, maxCenterCoordinateDistance: 2500)
        view.addSubview(mapView)
    }

}

//MARK: - MKMapViewDelegate

extension MapView : MKMapViewDelegate {

    // Registers each annotationview added to the map depending on type
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "item")
        
        annotationView.clusteringIdentifier = "cluster"
        annotationView.collisionMode = .circle
        annotationView.canShowCallout = true

        let circleImage = UIImage(systemName: "circle.fill")!
        var borderImage: UIImage
        var fillImage: UIImage
        
        var surveyState: SurveyState = .notSurveyed
        
        if annotation is MKClusterAnnotation {
            let memberAnnotations = (annotation as! MKClusterAnnotation).memberAnnotations
            let count = memberAnnotations.count
            let configuration = UIImage.SymbolConfiguration(font: fontSize(for: count))
            
            borderImage = circleImage.withConfiguration(configuration)
            fillImage = UIImage(systemName: "\(count).circle.fill", withConfiguration: configuration)!
            
            var didSubmit = [Bool]()
            
            for memberAnnotation in memberAnnotations {
                let item = (memberAnnotation as! ItemAnnotation).item
                didSubmit.append(repository.didSubmitToday(for: item))
            }
            
            if didSubmit.contains(false) && didSubmit.contains(true) {
                surveyState = .mix
            }
            
            if !didSubmit.contains(false) {
                surveyState = .surveyed
            }
            
        } else {
            let configuration = UIImage.SymbolConfiguration(font: fontSize(for: 1))
            
            borderImage = circleImage.withConfiguration(configuration)
            fillImage = borderImage
            
            let item = (annotation as! ItemAnnotation).item
    
            if repository.didSubmitToday(for: item) {
                surveyState = .surveyed
            }

            (annotation as! ItemAnnotation).updatePhotoCount()
        }
        
        switch surveyState {
        case .notSurveyed:
            annotationView.tintColor = .systemRed
        case .surveyed:
            annotationView.tintColor = .systemGreen
        case .mix:
            annotationView.tintColor = .systemYellow
        }
        
        annotationView.image = borderImage.withTintColor(.white)
        annotationView.addSubview(UIImageView(image: fillImage))

        return annotationView
    }
    
    // extensibly draw overlays on map based on type
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let typeString = NSStringFromClass(type(of: overlay))
        if let renderer = overlayManager.renderers[typeString] {
            return renderer.init(overlay: overlay)
        }
        return MKOverlayRenderer()
    }

}

//map marker font size
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



    


