//
//  loadView.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 12/16/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import UIKit

class LoadView: UIView {

    let indicator = UIActivityIndicatorView(style: .large)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "pp-trans-gray")
        setUpIndicator()
    }
    
    func setUpIndicator() {
        indicator.color = UIColor(named: "pp-text-color")
        addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        indicator.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
