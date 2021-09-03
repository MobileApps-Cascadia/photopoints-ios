//
//  DetailStack.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 1/10/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

// saves us some repitition above by allowing us to set the properties
// seen in the overriden init below
class DetailStack: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        alignment = .top
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
