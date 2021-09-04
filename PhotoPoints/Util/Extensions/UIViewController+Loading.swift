//
//  UIViewController+Loading.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 9/4/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

extension UIViewController {
    private var indicator: UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.frame = view.frame
        indicator.color = UIColor(named: "pp-text-color")
        indicator.startAnimating()
        return indicator
    }
    
    func showLoadingIndicator() {
        view.addSubview(indicator)
    }
    
    func removeLoadingIndicator() {
        for subview in view.subviews {
            if let indicatorView = subview as? UIActivityIndicatorView {
                indicatorView.removeFromSuperview()
            }
        }
    }
}
