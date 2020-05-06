//
//  PointItem.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 5/6/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import Foundation

enum PointItemType: String {
    case unknown
    case plant
    case creek
    case birdhouse
    case kiosk
    case restroom
}

class PointItem {
    
    let id: Int
    let point: Point
    var detail: PointDetail
    var images: [PointImage]
    
    init(id: Int, point: Point, detail: PointDetail, images: [PointImage]) {
        self.id = id
        self.point = point
        self.detail = detail
        self.images = images
    }
    
}
