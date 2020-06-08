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

@objc enum ImageCategory: Int, RealmEnum {
    case unknown = 0
    case full = 100
    case detail = 200
    case collection = 300
    case thumbnail = 400
}

class Image: Object {

    @objc dynamic var fileName: String?
    @objc dynamic var baseFileName: String? = nil
    @objc dynamic var id: String? = nil
    @objc dynamic var category: ImageCategory = .unknown
    @objc dynamic var title: String?
    @objc dynamic var desc: String?
    @objc dynamic var license: String?
    
    convenience init(filename: String, baseFileName: String? = nil, id: String? = nil, category: ImageCategory = .unknown,
                     title: String? = nil, description: String? = nil, license: String? = nil) {
        self.init()
        self.fileName = fileName
        self.baseFileName = baseFileName
        self.id = id
        self.category = category
        self.title = title
        self.desc = description
        self.license = license
    }
    
    override static func primaryKey() -> String? {
        return "fileName"
    }
}
