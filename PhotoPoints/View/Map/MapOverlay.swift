//
//  MapOverlay.swift
//  PhotoPoints
//
//  Created by Student Account on 12/12/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//


import Foundation
import MapKit

class MapOverlay: MKTileOverlay {
  override func url(forTilePath path: MKTileOverlayPath) -> URL {
    print("requested tile\tz:\(path.z)\tx:\(path.x)\ty:\(path.y)")

    let tilePath = Bundle.main.url(
      forResource: "\(path.y)",
      withExtension: "png",
      subdirectory: "tiles/\(path.z)/\(path.x)",
      localization: nil)

    if let tile = tilePath {
      return tile
    } else {
      return Bundle.main.url(
        forResource: "parchment",
        withExtension: "png",
        subdirectory: "tiles",
        localization: nil)!
      // swiftlint:disable:previous force_unwrapping
    }
  }
}

