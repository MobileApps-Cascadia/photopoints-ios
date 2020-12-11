//
//  MD5Hash.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 12/11/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import Foundation
import CryptoKit

func MD5(data: Data) -> String {
    let digest = Insecure.MD5.hash(data: data).map {
        String(format: "%02hhx", $0)
    }.joined()
    return digest
}
