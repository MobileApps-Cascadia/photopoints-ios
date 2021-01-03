//
//  Submission+CoreDataClass.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 12/31/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//
//

import Foundation
import CoreData


public class Submission: NSManagedObject {

    convenience init(date: Date) {
        
        self.init(entity: Submission.entity(), insertInto: Repository.instance.context)
        
        self.date = date
        self.uuid = UUID()
        
        // the rest of the properties are either optional or have default values in the core data model

    }
    
}
