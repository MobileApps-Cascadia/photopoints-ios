//
//  DashedBorderView.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 9/3/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

class DashBorderView: UIView {
    var dashLayer = CAShapeLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addDashedBorder()
    }
    
    func addDashedBorder() {
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 8)

        dashLayer.path = path.cgPath
        dashLayer.strokeColor = UIColor.darkGray.cgColor
        dashLayer.lineDashPattern = [8.2, 8.2]
        dashLayer.fillColor = UIColor.clear.cgColor
        dashLayer.frame = bounds
        
        layer.addSublayer(dashLayer)
    }
}
