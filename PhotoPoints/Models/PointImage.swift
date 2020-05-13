//
//  PointImage.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 5/6/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import Foundation
import UIKit

class PointImage {

    let id: Int
    let fileName: String
    let imageType: String
    let imageHeading: String
    let imageLicense: String
    
    init(id: Int, fileName: String, imageType: String, imageHeading: String, imageLicense: String) {
        self.id = id
        self.fileName = fileName
        self.imageType = imageType
        self.imageHeading = imageHeading
        self.imageLicense = imageLicense
    }
}
