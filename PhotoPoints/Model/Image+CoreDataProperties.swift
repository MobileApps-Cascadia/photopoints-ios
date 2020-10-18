//
//  Image+CoreDataProperties.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 8/18/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var baseFilename: String?
    @NSManaged public var type: Int
    @NSManaged public var desc: String?
    @NSManaged public var filename: String
    @NSManaged public var license: String?
    @NSManaged public var title: String?
    @NSManaged public var item: Item

}
