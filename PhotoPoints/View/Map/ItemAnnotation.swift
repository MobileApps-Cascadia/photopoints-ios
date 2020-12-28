//
//  CustomAnnotation.swift
//  PhotoPoints
//
//  Created by Grant Buchanan on 5/26/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import UIKit
import MapKit

//Enum for changing map marker states
enum SurveyState {
    case notSurveyed
    case surveyed
    case mix
}

class ItemAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    
    var title: String?
    
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
    
    var mapState = SurveyState.notSurveyed

    //Switch statement for changing the survey state of a photopoint. currently contains test code.
    func printState() {
        switch mapState {
        case .notSurveyed:
            print("Not surveyed")
        case .surveyed:
            print("Surveyed")
        case .mix:
            print("Mix")
        }
    }
}
