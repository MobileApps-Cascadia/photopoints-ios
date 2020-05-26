//
//  PointImage.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 5/6/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import Foundation
import UIKit
import Realm
import RealmSwift

@objc enum ImageType: Int, RealmEnum {
    case unknown = 0
    case full = 100
    case detail = 200
    case collection = 300
    case thumbnail = 400
}

class Image: Object {

    @objc dynamic var id: Int = -1
    @objc dynamic var fileName: String = ""
    @objc dynamic var imageType: ImageType = .unknown
    @objc dynamic var imageHeading: String = ""
    @objc dynamic var imageLicense: String = ""
    
    convenience init(id: Int, fileName: String, imageType: ImageType, imageHeading: String, imageLicense: String) {
        self.init()
        self.id = id
        self.fileName = fileName
        self.imageType = imageType
        self.imageHeading = imageHeading
        self.imageLicense = imageLicense
    }
    
    override static func primaryKey() -> String?
    {
        return "fileName"
    }
}
