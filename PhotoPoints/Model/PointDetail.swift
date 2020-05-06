//
//  PointDetails.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 5/6/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import Foundation

class PointDetail {
    
    let nameString: String
    let description: String
    let qrCode: String
    
    init(nameString: String, description: String, qrCode: String) {
        self.nameString = nameString
        self.description = description
        self.qrCode = qrCode
    }
    
}
