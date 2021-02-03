//
//  DataMd5.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 2/1/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import Foundation
import CryptoKit

extension Data {
    
    func md5() -> String {
        return Insecure.MD5.hash(data: self).map {
            String(format: "%02hhx", $0)
        }.joined()
    }
    
}
