//
//  PlantItem.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 4/7/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import Foundation
import UIKit
import MapKit

enum SurveyStatus: String {
    case surveyed = "surveyed"
    case notSurveyed = "not surveyed"
}

class PlantItem {
    
    let id: Int
    let coords: CLLocationCoordinate2D
    let commonName: String
    let botanicalName: String
    let site: Int
    let category: String?
    let family: String?
    let status: String
    var surveyStatus: SurveyStatus
    let urlString: String
    let image: UIImage

    
    init(id: Int, coords: CLLocationCoordinate2D, commonName: String, botanicalName: String, site: Int, category: String? = nil, family: String? = nil) {
        self.id = id
        self.coords = coords
        self.commonName = commonName
        self.botanicalName = botanicalName
        self.site = site
        self.category = category
        self.family = family
        self.surveyStatus = .notSurveyed
        
        // hard coded as every plant on PlantsMap seems to be alive...
        self.status = "Alive"
        self.urlString = "https://www.plantsmap.com/plants/\(id)"
        
        guard let image = UIImage(named: "\(id)_card_image") else {
            print("image error")
            fatalError()
        }
        
        self.image = image
    }
    
}
