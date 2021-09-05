//
//  Item.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 9/5/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import Foundation

struct Item: Codable {
    let id: String
    let enabled: Bool
    let label: String
    let type: String
    let url: String
    let details: [Detail]
    let images: [Image]
    let location: Coordinate
    
    enum CodingKeys: String, CodingKey {
        case id
        case enabled
        case label
        case type
        case url
        case details
        case images
        case location
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        guard let id = try container.decodeIfPresent(String.self, forKey: .id),
              let enabled = try container.decodeIfPresent(Bool.self, forKey: .enabled),
              let label = try container.decodeIfPresent(String.self, forKey: .label),
              let type = try container.decodeIfPresent(String.self, forKey: .type),
              let url = try container.decodeIfPresent(String.self, forKey: .url),
              let detailDict = try container.decodeIfPresent([String: String].self, forKey: .details),
              let images = try container.decodeIfPresent([Image].self, forKey: .images),
              let location = try container.decodeIfPresent(Coordinate.self, forKey: .location)
        else {
            throw NSError(domain: "Error decoding Item - expected key was not present", code: 0)
        }
        
        self.id = id
        self.enabled = enabled
        self.label = label
        self.type = type
        self.url = url
        
        // map dictionary to detail struct - the purpose of using init(from:) here
        self.details = detailDict.compactMap { Detail(property: $0, value: $1) }
        self.images = images
        self.location = location
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        var detailDict = [String: String]()
        
        details.forEach { detailDict[$0.property] = $0.value }
        
        try container.encode(id, forKey: .id)
        try container.encode(enabled, forKey: .enabled)
        try container.encode(label, forKey: .label)
        try container.encode(type, forKey: .type)
        try container.encode(url, forKey: .url)
        
        // use dictionary representation when uploading
        try container.encode(detailDict, forKey: .details)
        try container.encode(images, forKey: .images)
        try container.encode(location, forKey: .location)
    }
}
