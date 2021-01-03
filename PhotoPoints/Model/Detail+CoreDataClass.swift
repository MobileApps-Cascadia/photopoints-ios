//
//  Detail+CoreDataClass.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 8/18/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//
//

import UIKit
import CoreData

@objc(Detail)
public class Detail: NSManagedObject {

    // create a property from any type, converting to string. Default id is -1
    convenience init(property: String, value: Any?) {
        
        self.init(entity: Detail.entity(), insertInto: Repository.instance.context)
        
        self.property = property
        self.value = value as? String
    }
    
}
