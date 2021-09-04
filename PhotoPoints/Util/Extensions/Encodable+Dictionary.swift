//
//  Encodable+Dictionary.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 9/4/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import Foundation

extension Encodable {
    var dictionary: [String: Any] {
        let encoder = JSONEncoder()
        
        guard let data = try? encoder.encode(self),
              let dictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap({ $0 as? [String: Any] })
        else {
            return [:]
        }
        
        return dictionary
    }
}
