//
//  DetailTitle.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 1/10/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

class DetailTitle: UILabel {
    
    convenience init(string: String) {
        self.init()
        text = string
        textColor = UIColor(named: "pp-text-color")
        font = UIFont.systemFont(ofSize: 15, weight: .semibold)
    }

}
