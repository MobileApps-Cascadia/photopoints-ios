//
//  QrLookup.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 5/13/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import Foundation

class QrLookup {
    let id: Int
    let qrCode: String
    
    init(id: Int, qrCode: String) {
        self.id = id
        self.qrCode = qrCode
    }
}
