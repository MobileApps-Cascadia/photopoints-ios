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
    
    func setUpIndicator() {
        indicator.color = UIColor(named: "pp-text-color")
        addSubview(indicator)
        indicator.frame = frame
        indicator.startAnimating()
    }

}
