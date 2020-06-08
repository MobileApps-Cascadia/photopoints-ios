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

    @objc dynamic var filename: String = ""
    @objc dynamic var baseFilename: String? = nil
    @objc dynamic var id: String? = nil
    @objc dynamic var type: ImageType = .unknown
    @objc dynamic var title: String?
    @objc dynamic var desc: String?
    @objc dynamic var license: String?
    
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
