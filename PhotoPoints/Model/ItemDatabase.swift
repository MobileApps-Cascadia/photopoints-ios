//
//  ItemDatabase.swift
//  PhotoPoints
//
//  Created by Stephen Gomez-Fox on 1/2/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class ItemDatabase {
    static var items : [Item] = []
    
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
            
            // Get the id (cannot be nil)
            guard let id = jsonItem["id"] as? String else {
                print("jsonItem has no id")
                return
            }
            
            // Get the type (ex: "plant") -- "unknown" if nil
            let itemType = jsonItem["type"] as? String ?? "unknown"
            
            // Get the label -- empty string if nil
            let label = jsonItem["label"] as? String ?? ""
            
            // Get the barcode (currently stored as a url string)
            let qrCode = jsonItem["qr_code"] as? String ?? ""
            
            // Get the enabled flag -- disabled items are persistent but not shown
            let enabled = jsonItem["enabled"] as? Bool ?? false
            
            // Get the location as a dictionary containing coordinates
            guard let jsonLocation = jsonItem["location"] as? [String: Double] else {
                print("jsonItem does not contain a valid location" )
                return
            }
            
            // Get location coordinates
            let latitude = jsonLocation["latitude"]!
            let longitude = jsonLocation["longitude"]!
            let altitude = jsonLocation["altitude"]!
            
            // get the details
            let jsonDetails = jsonItem["details"] as? [String: Any] ?? [:]
            
            // extract the details and convert all to string
            var details : [String : String] = [:]
            
            for key : String in jsonDetails.keys {
                details[key] = (jsonDetails[key] as! String)
            }
            
            let jsonImages = jsonItem["images"] as? [Dictionary<String, Any>] ?? [[:]]
            
            // TODO: Implement multi-image handling -- Currently first is set an only
            
            let imageHash = jsonImages.first?["baseFilename"] as! String
            
            items.append(Item(
                            id: id,
                            type: itemType,
                            label: label,
                            code: qrCode,
                            location: Coordinate(
                                latitude: latitude,
                                longitude: longitude,
                                altitude: altitude),
                            details: details,
                            image: Image(filename: imageHash),
                            enabled: enabled
                            )
            )
        
        }
    }
}

    
    
    
