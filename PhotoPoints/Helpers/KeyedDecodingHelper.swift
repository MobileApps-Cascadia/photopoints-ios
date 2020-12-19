//
//  KeyedDecodingHelper.swift
//  PhotoPoints
//
//  Created by Stephen Gomez-Fox on 12/19/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import Foundation


// Create a CodingKey, reading a Dictionary Key from JSON

struct JSONCodingKeys: CodingKey {
    var stringValue: String
    var intValue: Int?
    
    init(stringValue: String) {
        self.stringValue = stringValue  
        self.intValue = Int(stringValue)
    }
    
    init?(intValue: Int) {
        self.init(stringValue: "\(intValue)")
        self.intValue = intValue
    }
}


// Create a container to decode a JSON Object as a Dictionary
extension KeyedDecodingContainer {
    
    func decode(_ type: [String: Any].Type) throws -> [String: Any] {
        var dictionary = [String: Any]()
        
        for key in allKeys {
            if let boolValue = try? decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = boolValue
            } else if let stringValue = try? decode(String.self, forKey: key) {
                dictionary[key.stringValue] = stringValue
            } else if let intValue = try? decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = intValue
            } else if let doubleValue = try? decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = doubleValue
            }
        }
        return dictionary
    }
}


// Decode an Array
extension UnkeyedDecodingContainer {
    mutating func decode(_ type: [Any].Type) throws -> [Any] {
        var array: [Any] = []
        
        while !isAtEnd {
            let value: String? = try decode(String?.self)
            guard value != nil else { continue }
            
            if let value = try? decode(Bool.self) {
                array.append(value)
            } else if let value = try? decode(Int.self) {
                array.append(value)
            } else if let value = try? decode(Double.self) {
                array.append(value)
            } else if let value = try? decode(String.self) {
                array.append(value)
            }
        }
        return array
    }
}
