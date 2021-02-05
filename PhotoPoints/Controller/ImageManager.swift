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

enum SubDirectory: String {
    case images = "images"
    case photos = "photos"
}

class ImageManager {
    
    static let fm = FileManager.default
    
    // output is not optional because we are just appending to a URL we know exists (document dir)
    static func getPath(for fileName: String, in subDirectory: SubDirectory) -> URL {
        
        // get the document directory URL, force unwrap as this will always exist
        let documentURL = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // navigate to specified subdirectory
        let imageURL = documentURL.appendingPathComponent("\(subDirectory)/")
        
        // tack on the photo hash + png to get the full URL
        return imageURL.appendingPathComponent(fileName + ".png")
        
    }

    // optional output - could enter a bad name
    static func getImage(from fileName: String, in subDirectory: SubDirectory) -> UIImage? {
        
        // file name > path > contents at path > UIImage with those contents returned
        let imagePath = getPath(for: fileName, in: subDirectory)
        if let fileData = fm.contents(atPath: imagePath.path), let image = UIImage(data: fileData) {
            return image
        }
        
        return nil
    }
    
    // orientation parameter to handle automatic rotation from camera sourced images
    static func getImage(from fileName: String, in subDirectory: SubDirectory, orientation: UIImage.Orientation) -> UIImage? {
        
        // file name > path > contents at path > UIImage with those contents returned
        let imagePath = getPath(for: fileName, in: subDirectory)
        if let fileData = fm.contents(atPath: imagePath.path), let image = UIImage(data: fileData) {
            return UIImage(cgImage: image.cgImage!, scale: 1, orientation: orientation)
        }
        
        return nil
    }
    
    
    static func storeImage(image: UIImage, with fileName: String, to subDirectory: SubDirectory) {
        
        // UIImage has pngData method
        if let pngRepresentation = image.pngData() {
            
            // save to disk
            let filePath = getPath(for: fileName, in: subDirectory)
            do {
                // Data has a write method
                try pngRepresentation.write(to: filePath, options: .atomic)
                
            } catch {
                print("Saving file resulted in error: ", error)
            }
        }
    }
    
}
