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
    
    func show(in view: UIView) {
        frame = view.frame
        setUpIndicator()
        view.addSubview(self)
    }
    
    func remove() {
        removeFromSuperview()
    }
    
    func setUpIndicator() {
        indicator.color = UIColor(named: "pp-text-color")
        addSubview(indicator)
        indicator.frame = frame
        indicator.startAnimating()
    }

}
