//
//  SimpleAnnotation.swift
//  PhotoPoints
//
//  Created by Grant Buchanan on 5/26/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import MapKit

class SimpleAnnotation: NSObject, MKAnnotation {
    
    // This property must be key-value observable, which the `@objc dynamic` attributes provide.
    @objc dynamic var coordinate = CLLocationCoordinate2D(latitude: 47.778836, longitude: -122.194417)
    
    // Required if you set the annotation view's `canShowCallout` property to `true`
    var title: String? = NSLocalizedString("Test", comment: "Test annotation")
    
    // Optional subtitle property.
    var subtitle: String? = NSLocalizedString("Test", comment: "Test annotation")
    
}
