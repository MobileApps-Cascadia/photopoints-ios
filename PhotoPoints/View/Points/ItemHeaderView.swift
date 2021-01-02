//
//  ItemHeaderView.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 1/1/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

class ItemHeaderView: UICollectionReusableView {
    
    let repository = Repository.instance
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let pointCountLabel = UILabel()
        let numPoints = repository.getItems()?.count ?? 0
        pointCountLabel.text = "\(numPoints) PhotoPoints"
        
        let dateLabel = UILabel()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        let dayString = formatter.string(from: Date())
        dateLabel.text = dayString
        
        let progressCircle = UIView()
        progressCircle.anchor(width: 60, height: 60)
        progressCircle.backgroundColor = .systemGreen
        progressCircle.layer.cornerRadius = 30
        
        let labelStack = UIStackView()
        labelStack.axis = .vertical
        labelStack.addArrangedSubview(pointCountLabel)
        labelStack.addArrangedSubview(dateLabel)
        
        let mainStack = UIStackView()
        mainStack.axis = .horizontal
        mainStack.addArrangedSubview(labelStack)
        mainStack.addArrangedSubview(progressCircle)
        
        addSubview(mainStack)
        mainStack.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
