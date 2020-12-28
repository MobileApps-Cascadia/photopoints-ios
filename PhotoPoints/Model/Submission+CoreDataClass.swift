//
//  Submission+CoreDataClass.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 12/27/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(Submission)
public class Submission: NSManagedObject {

    convenience init(userPhoto: UserPhoto, date: Date) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        self.init(entity: Submission.entity(), insertInto: context)
        
        addToUserPhoto(userPhoto)
        self.date = date
        self.uuid = UUID()
        
        // the rest of the properties are either optional or have default values in the core data model

    }
    
}
