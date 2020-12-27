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
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        self.init(entity: UserPhoto.entity(), insertInto: context)
        
        self.photoHash = photoHash
        self.photoUrl = photoUrl
    }
    
}
