//
//  Submission+CoreDataProperties.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 12/31/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//
//

import Foundation
import CoreData


extension Submission {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Submission> {
        return NSFetchRequest<Submission>(entityName: "Submission")
    }

    @NSManaged public var answers: String?
    @NSManaged public var count: Int16
    @NSManaged public var date: Date?
    @NSManaged public var notes: String?
    @NSManaged public var status: String?
    @NSManaged public var uuid: UUID?
    @NSManaged public var item: Item?
    @NSManaged public var userPhotos: NSSet?

}

// MARK: Generated accessors for userPhotos
extension Submission {

    @objc(addUserPhotosObject:)
    @NSManaged public func addToUserPhotos(_ value: UserPhoto)

    @objc(removeUserPhotosObject:)
    @NSManaged public func removeFromUserPhotos(_ value: UserPhoto)

    @objc(addUserPhotos:)
    @NSManaged public func addToUserPhotos(_ values: NSSet)

    @objc(removeUserPhotos:)
    @NSManaged public func removeFromUserPhotos(_ values: NSSet)

}

extension Submission : Identifiable {

}
