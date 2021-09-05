//
//  JSONDecoder+Decode.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 9/5/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import Foundation

extension JSONDecoder {
    func decode<T: Decodable>(_ type: T.Type, from dictionary: [String: Any]) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        return try self.decode(T.self, from: data)
    }
}
