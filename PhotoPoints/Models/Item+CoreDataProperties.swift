//
//  Item+CoreDataProperties.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 8/16/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var details: [Detail]?
    @NSManaged public var id: Int64
    @NSManaged public var images: [Images]?
    @NSManaged public var point: Point?

}
