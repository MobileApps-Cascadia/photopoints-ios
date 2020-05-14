//
//  PointItem.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 5/13/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import Foundation

protocol PointItem {
    var id: Int { get }
    var point: Point { get }
    var detail: PointDetail { get }
    var images: [PointImage] { get }
}
