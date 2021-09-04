//
//  SectionHeader.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 1/9/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

class SectionHeader: UIView {
    
    let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    var paddingLeft: CGFloat = .globalPadding
    var paddingBottom: CGFloat = 2
    
    convenience init(title: String, isInset: Bool = true) {
        self.init()
        self.title.text = title
        
        if !isInset {
            paddingLeft = 0
            paddingBottom = 4
        }
        
        setupSubviews()
    }
    
    func setupSubviews() {
        
        
        addSubview(title)
        title.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            paddingTop: .globalPadding,
            paddingLeft: paddingLeft,
            paddingBottom: paddingBottom,
            paddingRight: .globalPadding
        )
    }
    
}
