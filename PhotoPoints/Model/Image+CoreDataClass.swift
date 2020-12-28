//
//  Image+CoreDataClass.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 8/18/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//
//

import UIKit
import CoreData

@objc(Image)
public class Image: NSManagedObject {

    convenience init(filename: String, baseFilename: String? = nil, title: String? = nil, desc: String? = nil, license: String? = nil) {
              
        self.init(entity: Image.entity(), insertInto: Repository.instance.context)
        
        self.filename = filename
        self.type = 100
        if let bfn = baseFilename { self.baseFilename = bfn }
        if let ttl = title { self.title = ttl }
        if let dsc = desc { self.desc = dsc }
    }
    
}
