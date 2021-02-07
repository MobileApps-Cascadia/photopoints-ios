//
//  ItemDatabase.swift
//  PhotoPoints
//
//  Created by Stephen Gomez-Fox on 1/2/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class ItemDatabase {
    static var items : [Item] = []
    
    private static let repository = Repository.instance
    
    static func build(from: String) {
        let data : Data = from.data(using:.utf8)!
        
        // Decode json into array of dictionary objects
        // TODO: Implement error handling
        let jsonItems: [Dictionary<String, Any>] = try! JSONSerialization.jsonObject(with: data, options: []) as! [Dictionary<String, Any>]
        
        // ensure the array contains at least one item
        if jsonItems.count == 0 {
            print("JSON string for Items must be an array")
            return
        }
        
        // iterate jsonItems to build each Item
        for jsonItem in jsonItems {
            
            let item = Item(context: repository.context)
            
            // Get the id (cannot be nil)
            guard let id = jsonItem["id"] as? String else {
                print("jsonItem has no id")
                return
            }
            
            item.id = id
            
            // Get the type (ex: "plant") -- "unknown" if nil
            item.type = jsonItem["type"] as? String ?? "unknown"
            
            // Get the label -- empty string if nil
            item.label = jsonItem["label"] as? String ?? ""
            
            // Get the barcode (currently stored as a url string)
            item.url = jsonItem["qr_code"] as? String ?? ""
            
            // Get the enabled flag -- disabled items are persistent but not shown
            item.enabled = jsonItem["enabled"] as? Bool ?? false
            
            let jsonImages = jsonItem["images"] as? [Dictionary<String, Any>] ?? [[:]]
            
            // TODO: Implement multi-image handling -- Currently first is set an only
            let image = Image(context: repository.context)
            image.basefile = (jsonImages.first?["basefile"] as! String)
            image.filename = image.basefile
            item.addToImages(image)
            
            // Get the location as a dictionary containing coordinates
            guard let jsonLocation = jsonItem["location"] as? [String: Double] else {
                print("jsonItem does not contain a valid location" )
                return
            }
            
            // Get location coordinates and input into Coordinate object
            let location = Coordinate(context: repository.context)
            location.latitude = jsonLocation["latitude"]!
            location.longitude = jsonLocation["longitude"]!
            location.altitude = jsonLocation["altitude"]!
            item.location = location
            
            // get the details
            let jsonDetails = jsonItem["details"] as? [String: Any] ?? [:]
            
            // extract the details, convert values to string, and add to item's details
            for key : String in jsonDetails.keys {
                let detail = Detail(context: repository.context)
                detail.property = key
                detail.value = (jsonDetails[key] as! String)
                item.addToDetails(detail)
            }
            
            items.append(item)
        
        }
    }
}

    
    
    
