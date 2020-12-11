//
//  PlantsCollectionCell.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 4/24/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import Foundation
import UIKit

class ItemCollectionCell: UICollectionViewCell {
    
    let repository = Repository.instance
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        // without this, we get a bad lagging effect on the image when returning from detail view
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "pp-text-color")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "pp-text-color")
        label.textAlignment = .center
        label.font = UIFont.italicSystemFont(ofSize: 12)
        return label
    }()
    
    // translucent gray background bar for text
    let cardFooter: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "pp-trans-gray")
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpSubViews() {
        cardFooter.addSubview(titleLabel)
        titleLabel.anchor(top: cardFooter.topAnchor, left: cardFooter.leftAnchor, bottom: cardFooter.centerYAnchor, right: cardFooter.rightAnchor, paddingTop: 5)
        
        cardFooter.addSubview(subTitleLabel)
        subTitleLabel.anchor(top: cardFooter.centerYAnchor, left: cardFooter.leftAnchor, bottom: cardFooter.bottomAnchor, right: cardFooter.rightAnchor, paddingBottom: 5)
        
        imageView.addSubview(cardFooter)
        cardFooter.anchor(top: imageView.bottomAnchor, left: imageView.leftAnchor, bottom: imageView.bottomAnchor, right: imageView.rightAnchor, paddingTop: -50)
        
        contentView.addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        imageView.layer.cornerRadius = 20
    }
    
    func configureFor(item: Item) {
        imageView.image = repository.getImageFromFilesystem(item: item)
        titleLabel.text = item.label 
        subTitleLabel.text = repository.getDetailValue(item: item, property: "botanical_name")
    }
    
}
