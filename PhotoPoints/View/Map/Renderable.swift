//
//  Renderable.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 3/11/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import MapKit

protocol Renderable {
    func render() -> MKOverlayRenderer
}
