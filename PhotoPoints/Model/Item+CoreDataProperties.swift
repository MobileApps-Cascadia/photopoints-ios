//
//  Item+CoreDataProperties.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 8/18/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var id: String
    @NSManaged public var enabled: Bool
    @NSManaged public var label: String?
    @NSManaged public var url: String?
    @NSManaged public var location: Coordinate?
    @NSManaged public var images: NSSet?
    @NSManaged public var details: NSSet?

}

// MARK: Generated accessors for images
extension Item {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: Image)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: Image)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}

// MARK: Generated accessors for details
extension Item {

    @objc(addDetailsObject:)
    @NSManaged public func addToDetails(_ value: Detail)

    @objc(removeDetailsObject:)
    @NSManaged public func removeFromDetails(_ value: Detail)

    @objc(addDetails:)
    @NSManaged public func addToDetails(_ values: NSSet)

    @objc(removeDetails:)
    @NSManaged public func removeFromDetails(_ values: NSSet)

}
