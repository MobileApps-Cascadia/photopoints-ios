//
//  CustomAnnotation.swift
//  PhotoPoints
//
//  Created by Grant Buchanan on 5/26/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import UIKit
import MapKit

class ItemAnnotation: NSObject, MKAnnotation {
    
    // This property must be key-value observable, which the `@objc dynamic` attributes provide.
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    // Empty callout variables for use later
    var title: String?
    
    var subtitle: String?
    
    var imageName: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
    
    //Enum for changing map marker states
       enum SurveyState {
           case unsurveyed
           case surveyed
           case visited
           case unvisted
       }
       
       var mapState = SurveyState.unvisted
       
       //Switch statement for changing the survey state of a photopoint. currently contains test code.
       func switchState() {
           switch mapState {
           case .unsurveyed:
               print("Unsurveyed")
           case .surveyed:
               print("Surveyed")
           case .visited:
               print("Visted")
           case .unvisted:
               print("Unvisted")
            
           }
       }
}
