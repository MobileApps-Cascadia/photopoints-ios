//
//  PointItem.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 5/13/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Item: Object {
    @objc dynamic var id = -1
    @objc dynamic var point: Point? = nil
    let details = List<Detail>()
    let images = List<Image>()

    required init() {}
    required init(id: Int, point: Point, detail: [String: String], images: [Image]) {
        self.id = id
        self.point = point
        for (k, v) in detail {
            let detail = Detail(id: self.id, property: k, value: v)
            if detail.id >= 0 {
                details.append(detail)
            }
        }
        for image in images {
            self.images.append(image)
        }
    }
}
