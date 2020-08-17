//
//  Lookup+CoreDataProperties.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 8/16/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//
//

import Foundation
import CoreData


extension Lookup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lookup> {
        return NSFetchRequest<Lookup>(entityName: "Lookup")
    }

    @NSManaged public var id: Int64
    @NSManaged public var search: String?

}
