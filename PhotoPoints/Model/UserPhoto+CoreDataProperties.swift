//
//  UserPhoto+CoreDataProperties.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 12/27/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//
//

import Foundation
import CoreData


extension UserPhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserPhoto> {
        return NSFetchRequest<UserPhoto>(entityName: "UserPhoto")
    }

    @NSManaged public var photoHash: String?
    @NSManaged public var photoSize: Int32
    @NSManaged public var photoUrl: URL?
    @NSManaged public var result: String?
    @NSManaged public var submitToUrl: URL?
    @NSManaged public var uploaded: Bool
    @NSManaged public var submission: Submission?

}

extension UserPhoto : Identifiable {

}
