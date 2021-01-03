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
    
    // main background of each cell
    let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "pp-trans-gray")
        view.layer.cornerRadius = 10
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        // without this, we get a bad lagging effect on the image when returning from detail view
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 22
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "pp-text-color")
        label.font = UIFont.systemFont(ofSize: 19)
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "pp-secondary-text-color")
        label.font = UIFont.italicSystemFont(ofSize: 13)
        return label
    }()

    // indicate if an item has been surveyed
    var statusCircle: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        return view
    }()
    
    var countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() {
        
        statusCircle.addSubview(countLabel)
        countLabel.anchor(top: statusCircle.topAnchor, left: statusCircle.leftAnchor, bottom: statusCircle.bottomAnchor, right: statusCircle.rightAnchor)
        
        mainView.addSubview(statusCircle)
        statusCircle.anchor(right: mainView.rightAnchor, centerY: mainView.centerYAnchor, paddingRight: 16, width: 24, height: 24)
        
        mainView.addSubview(imageView)
        imageView.anchor(left: mainView.leftAnchor, centerY: mainView.centerYAnchor, paddingLeft: 16, width: 44, height: 44)
        
        mainView.addSubview(titleLabel)
        titleLabel.anchor(top: imageView.topAnchor, left: imageView.rightAnchor, paddingLeft: 8)
        
        mainView.addSubview(subTitleLabel)
        subTitleLabel.anchor(left: imageView.rightAnchor, bottom: imageView.bottomAnchor, paddingLeft: 8)
        
        contentView.addSubview(mainView)
        mainView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 2, paddingLeft: 16, paddingBottom: 2, paddingRight: 16)
        
    }
    
    func configureFor(item: Item) {
        imageView.image = repository.getImageFromFilesystem(item: item)
        titleLabel.text = item.label 
        subTitleLabel.text = repository.getDetailValue(item: item, property: "botanical_name")
        
        if repository.didSubmitToday(for: item) {
            statusCircle.backgroundColor = .systemGreen
            countLabel.text = String(repository.getTodaysUserPhotos(for: item).count)
        } else {
            statusCircle.backgroundColor = .systemRed
            countLabel.text = ""
        }
    }
    
}
