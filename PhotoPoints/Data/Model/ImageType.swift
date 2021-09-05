//
//  ImageType.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 9/4/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import Foundation

enum ImageType: Int16, RawRepresentable, Codable {
    case unknown = 0
    case full = 100
    case detail = 200
    case collection = 300
    case thumbnail = 400
    
    static var typeDict: [String: ImageType] {
        return [
            "unknown": .unknown,
            "full": .full,
            "detail": .detail,
            "collection": .collection,
            "thumbnail": .thumbnail
        ]
    }
    
    var description: String {
        switch self {
        case .unknown:
            return "unknown"
        case .full:
            return "full"
        case .detail:
            return "detail"
        case .collection:
            return "collection"
        case .thumbnail:
            return "thumbnail"
        }
    }
    
    init(description: String) {
        if let imageType = ImageType.typeDict[description] {
            self = imageType
        } else {
            self = .unknown
        }
    }
}
