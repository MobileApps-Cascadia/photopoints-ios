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
    
    convenience init(title: String) {
        self.init()
        self.title.text = title
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
            paddingLeft: .globalPadding,
            paddingBottom: 2,
            paddingRight: .globalPadding
        )
    }
    
}
