//
//  Submission+CoreDataProperties.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 12/27/20.
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
    @NSManaged public var itemIId: String?
    @NSManaged public var notes: String?
    @NSManaged public var status: String?
    @NSManaged public var uuid: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var item: Item?
    @NSManaged public var userPhoto: NSSet?

}

// MARK: Generated accessors for userPhoto
extension Submission {

    @objc(addUserPhotoObject:)
    @NSManaged public func addToUserPhoto(_ value: UserPhoto)

    @objc(removeUserPhotoObject:)
    @NSManaged public func removeFromUserPhoto(_ value: UserPhoto)

    @objc(addUserPhoto:)
    @NSManaged public func addToUserPhoto(_ values: NSSet)

    @objc(removeUserPhoto:)
    @NSManaged public func removeFromUserPhoto(_ values: NSSet)

}

extension Submission : Identifiable {

}
