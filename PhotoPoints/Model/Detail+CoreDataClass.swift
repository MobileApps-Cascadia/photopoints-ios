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
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        self.init(entity: Detail.entity(), insertInto: context)
        
        self.property = property
        self.value = value as? String
    }
    
}
