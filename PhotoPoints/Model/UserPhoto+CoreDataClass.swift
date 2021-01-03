//
//  UserPhoto+CoreDataClass.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 12/27/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(UserPhoto)
public class UserPhoto: NSManagedObject {
    
    convenience init(photoHash: String, photoUrl: URL) {

        self.init(entity: UserPhoto.entity(), insertInto: Repository.instance.context)
        
        self.photoHash = photoHash
        self.photoUrl = photoUrl
        
        // the rest of the properties are either optional or have default values in the core data model
    }
    
}
