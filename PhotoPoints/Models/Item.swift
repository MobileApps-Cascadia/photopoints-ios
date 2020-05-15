//
//  PointItem.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 5/13/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import Foundation

class Item {
    let id: Int
    let point: Point
    let detail: [String: String]
    let images: [PointImage]
    
    init(id: Int, point: Point, detail: [String: String], images: [PointImage]) {
        self.id = id
        self.point = point
        self.detail = detail
        self.images = images
    }
}
