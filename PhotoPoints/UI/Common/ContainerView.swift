//
//  ContainerView.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 9/3/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

@IBDesignable
class ContainerView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 8
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = cornerRadius
        backgroundColor = .systemGray5
    }
}
