//
//  ImageManager.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 5/12/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//
// code modified from https://programmingwithswift.com/save-images-locally-with-swift-5/

import Foundation
import UIKit

enum ImageDirectory {
    case submission
    case application
}

class ImageManager {
    
    // optional output - could enter a bad name
    static func getPath(for fileName: String) -> URL? {
        
        // get the document directory URL
        guard let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
                
        // tack on the photo hash + png to get the full URL
        return documentURL.appendingPathComponent(fileName + ".png")
        
    }

    // optional output - could enter a bad name
    static func getImage(from fileName: String) -> UIImage? {
        
        // file name -> path -> contents at path -> UIImage with those contents returned
        if let imagePath = getPath(for: fileName), let fileData = FileManager.default.contents(atPath: imagePath.path), let image = UIImage(data: fileData) {
            return image
        }
        
        return nil
    }
    
    static func storeImage(image: UIImage, with fileName: String) {
        
        // UIImage has pngData method
        if let pngRepresentation = image.pngData() {
            // save to disk
            // filePath returns optional URL
            if let filePath = getPath(for: fileName){
                do {
                    // Data has a write method
                    try pngRepresentation.write(to: filePath, options: .atomic)
                } catch let err {
                    print("Saving file resulted in error: ", err)
                }
            }
        }
    }
    
}
