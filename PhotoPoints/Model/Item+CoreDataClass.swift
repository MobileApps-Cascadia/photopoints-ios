//
//  Item+CoreDataClass.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 12/27/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit


public class Item: NSManagedObject {

    convenience init(id: String, label: String, coordinate: Coordinate, details: [String: String], image: Image) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        self.init(entity: Item.entity(), insertInto: context)
        
        self.id = id
        self.label = label
        self.location = coordinate
        self.url = "https://www.plantsmap.com/plants/\(id)"
        self.enabled = true
        addToImages(image)
        addDetails(details: details)
        
    }
    
    func addDetails(details: [String : String]) {
        for detail in details {
            self.addToDetails(Detail(property: detail.key, value: detail.value))
        }
    }
    
}
