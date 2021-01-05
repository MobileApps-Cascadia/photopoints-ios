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

    convenience init(id: String, type: String, label: String, code: String, location: Coordinate, details: [String: String], image: Image, enabled: Bool = true) {

        self.init(entity: Item.entity(), insertInto: Repository.instance.context)
        
        self.id = id
        self.label = label
        self.location = location
        //TODO: refactor "url" to "code" or similar. Format changing in future per client
        self.url = code
        self.enabled = enabled
        addToImages(image)
        addDetails(details: details)
        
    }
    
    func addDetails(details: [String : String]) {
        for detail in details {
            self.addToDetails(Detail(property: detail.key, value: detail.value))
        }
    }
    
}
