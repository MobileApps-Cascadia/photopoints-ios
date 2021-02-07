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
    
    var coordinate: CLLocationCoordinate2D
    
    var title: String?
    
    var subtitle: String?
    
    let item: Item
    
    let repository = Repository.instance
    
    init(item: Item) {
        self.item = item
        let location = item.location!
        self.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        self.title = item.label
        super.init()
        updatePhotoCount()
    }
    
    func updatePhotoCount() {
        if repository.didSubmitToday(for: item) {
            let count = repository.getTodaysUserPhotos(for: item).count
            self.subtitle = "\(count) photo\(count == 1 ? "" : "s") sent today"
        } else {
            self.subtitle = "no photos sent today"
        }
    }
}
