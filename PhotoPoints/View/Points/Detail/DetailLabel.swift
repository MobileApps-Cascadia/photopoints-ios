//
//  DetailLabel.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 1/10/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

class DetailLabel: UILabel {
    
    init(string: String) {
        
        // this frame size will be overriden below
        // have to pass in this superclass init for our override
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        text = string
        textColor = UIColor(named: "pp-secondary-text-color")
        font = UIFont.systemFont(ofSize: 19, weight: .regular)
        numberOfLines = 0
        
        // override frame above, size the label to fit text
        self.sizeToFit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
