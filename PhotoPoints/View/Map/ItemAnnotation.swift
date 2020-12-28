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
    
    let item: Item
    
    init(item: Item) {
        self.item = item
        let location = item.location!
        self.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        self.title = item.label
        super.init()
    }
}
