//
//  PointImage.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 5/6/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

// code modified from https://programmingwithswift.com/save-images-locally-with-swift-5/

import Foundation
import UIKit

class PointImage {

    let id: Int
    let fileName: String
    let imageType: String
    let imageHeading: String
    let imageLicense: String
    
    lazy var imagePath: URL? = {
        
        // get the document directory URL
        guard let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        // tack on the photo hash + png to get the full URL
        return documentURL.appendingPathComponent(fileName + ".png")
    }()
    
    lazy var image: UIImage? = {
        
        // file name -> path -> contents at path -> UIImage with those contents returned
        if let imagePath = imagePath, let fileData = FileManager.default.contents(atPath: imagePath.path), let image = UIImage(data: fileData) {
            return image
        }
        
        return nil
    }()
    
    init(id: Int, fileName: String, imageType: String, imageHeading: String, imageLicense: String) {
        self.id = id
        self.fileName = fileName
        self.imageType = imageType
        self.imageHeading = imageHeading
        self.imageLicense = imageLicense
    }
}
