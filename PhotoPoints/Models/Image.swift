//
//  PointImage.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 5/6/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import Foundation
import UIKit

@objc enum ImageType: Int, RealmEnum {
    case unknown = 0
    case full = 100
    case detail = 200
    case collection = 300
    case thumbnail = 400
}

class Image {

    var filename: String = ""
    var baseFilename: String? = nil
    var id: String? = nil
    var type: ImageType = .unknown
    var title: String?
    var desc: String?
    var license: String?
    
    convenience init(filename: String, baseFilename: String? = nil, id: String? = nil, type: ImageType = .unknown,
                     title: String? = nil, desc: String? = nil, license: String? = nil) {
        self.init()
        self.type = type
        self.filename = filename
        if let bfn = baseFilename { self.baseFilename = bfn }
        if let itemId = id { self.id = itemId }
        if let ttl = title { self.title = ttl }
        if let dsc = desc { self.desc = dsc }
        
    }
    
}
