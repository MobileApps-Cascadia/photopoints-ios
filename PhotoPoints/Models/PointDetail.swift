//
//  PointDetail.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 5/13/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import Foundation

protocol PointDetail {
    var id: Int { get }
    var nameString: String { get }
    var description: String { get }
}
