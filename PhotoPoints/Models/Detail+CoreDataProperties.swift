//
//  Detail+CoreDataProperties.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 8/16/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//
//

import Foundation
import CoreData


extension Detail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Detail> {
        return NSFetchRequest<Detail>(entityName: "Detail")
    }

    @NSManaged public var id: Int64
    @NSManaged public var property: String?
    @NSManaged public var value: String?

}
