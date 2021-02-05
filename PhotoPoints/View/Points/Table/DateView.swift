//
//  PointsHeaderView.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 1/9/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

class DateView: UIView {
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = Date().headerStyle()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    convenience init(paddingTop: CGFloat) {
        self.init()
        addSubview(dateLabel)
        dateLabel.anchor(
            top: topAnchor,
            left: leftAnchor,
            paddingTop: paddingTop,
            paddingLeft: .globalPadding
        )
    }
    
    func fadeOutDate() {
        dateLabel.alpha = 0
    }
    
    func fadeInDate() {
        UIView.animate(withDuration: 0.2, delay: 0.3, options: .curveEaseInOut, animations: {
            self.dateLabel.alpha = 1
        }, completion: nil)
    }
    
}

extension Date {
    func headerStyle() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .full
        let dayString = String(formatter.string(from: Date()).uppercased().dropLast(6))
        return dayString
    }
}
