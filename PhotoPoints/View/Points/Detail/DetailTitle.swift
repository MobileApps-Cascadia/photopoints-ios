//
//  DetailTitle.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 1/10/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

// saves us some repitition above by allowing us to set the properties
// seen in our custom init below

class DetailTitle: UILabel {
    
    init(string: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        text = string
        textColor = UIColor(named: "pp-text-color")
        font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        self.sizeToFit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
