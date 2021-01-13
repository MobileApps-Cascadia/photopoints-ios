//
//  DetailLabel.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 1/10/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

class DetailLabel: UILabel {
    
    convenience init(string: String) {
        self.init()
        text = string
        textColor = UIColor(named: "pp-secondary-text-color")
        font = UIFont.systemFont(ofSize: 19, weight: .regular)
        numberOfLines = 0
    }
    
}
