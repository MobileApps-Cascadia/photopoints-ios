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

enum ImageDirectory: String {
    case submission = "submisssion"
    case application = "application"
}

class ImageManager {
    
    static let fm = FileManager.default
    
    // optional output - could enter a bad name
    static func getPath(for fileName: String, in directory: ImageDirectory) -> URL? {
        
        // get the document directory URL
        guard let documentURL = fm.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        // navigate to images subdirectory
        let imageURL = documentURL.appendingPathComponent("\(directory)/")
        
        // create the subdirectory if it does not exist
        if (try? imageURL.checkResourceIsReachable()) == nil {
            do {
                try fm.createDirectory(at: imageURL, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("error in creating images directory: \(error.localizedDescription)")
            }
        }
        
        // tack on the photo hash + png to get the full URL
        return imageURL.appendingPathComponent(fileName + ".png")
        
    }

    // optional output - could enter a bad name
    static func getImage(from fileName: String, in directory: ImageDirectory) -> UIImage? {
        
        // file name > path > contents at path > UIImage with those contents returned
        if let imagePath = getPath(for: fileName, in: directory), let fileData = fm.contents(atPath: imagePath.path), let image = UIImage(data: fileData) {
            return image
        }
        
        return nil
    }
    
    static func storeImage(image: UIImage, with fileName: String, to directory: ImageDirectory) {
        
        // UIImage has pngData method
        if let pngRepresentation = image.pngData() {
            // save to disk
            // filePath returns optional URL
            if let filePath = getPath(for: fileName, in: directory){
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
