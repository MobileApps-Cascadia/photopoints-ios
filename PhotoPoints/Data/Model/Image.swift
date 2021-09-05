//
//  Image.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 9/5/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import Foundation

struct Image: Codable {
    let basefile: String
    let desc: String?
    let filename: String
    let fileformat: String
    let license: String?
    let title: String?
    let imageType: String
    
    var fullFilename: String {
        return filename + "." + fileformat
    }
}
