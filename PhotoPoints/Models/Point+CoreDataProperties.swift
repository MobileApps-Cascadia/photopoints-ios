//
//  Point+CoreDataProperties.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 8/16/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//
//

import Foundation
import CoreData


extension Point {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Point> {
        return NSFetchRequest<Point>(entityName: "Point")
    }

    @NSManaged public var enabled: Bool
    @NSManaged public var id: Int64
    @NSManaged public var label: String?
    @NSManaged public var location: Coordinate?

}
