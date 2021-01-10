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
        label.font = UIFont.systemFont(ofSize: 22)
        return label
    }()
    
    func setTitle(title: String) {
        self.title.text = title
    }
    
    func setupSubviews() {
        addSubview(title)
        title.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 2, paddingLeft: globalPadding, paddingBottom: 2, paddingRight: globalPadding)
    }
    
}
