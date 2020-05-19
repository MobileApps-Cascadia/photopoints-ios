//
//  File.swift
//  PhotoPoints
//
//  Created by Student Account on 5/10/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import Foundation
import MapKit
//Subclass of MKPointAnnotation to allow for changing the appearance of a map maker based on the survey state of its associated photopoint.

class AnnotationDisplay : MKPointAnnotation{
    
    //Enum for changing map marker states
    enum SurveyState{
        case unsurveyed
        case surveyed
        case visited
        case unvisted
    }
    
    var mapState = SurveyState.unvisted
    
    //Switch statement for changing the survey state of a photopoint. currently contains test code.
    func switchState(){
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
