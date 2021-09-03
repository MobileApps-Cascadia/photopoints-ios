//
//  PointsCell.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 1/9/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

class PointCell: BaseCell {
    
    let repository = Repository.instance

    let cellImageView: UIImageView = {
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
    
    convenience init() {
        self.init()
        setupSubviews()
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        contentView.anchor(
            width: .screenWidth,
            height: 80
        )
        
        statusCircle.addSubview(countLabel)
        countLabel.pin(to: statusCircle)
        
        mainView.addSubview(statusCircle)
        statusCircle.anchor(
            right: mainView.rightAnchor,
            centerY: mainView.centerYAnchor,
            paddingRight: .globalPadding,
            width: 24,
            height: 24
        )
        
        mainView.addSubview(cellImageView)
        cellImageView.anchor(
            left: mainView.leftAnchor,
            centerY: mainView.centerYAnchor,
            paddingLeft: .globalPadding,
            width: 44,
            height: 44
        )
        
        mainView.addSubview(titleLabel)
        titleLabel.anchor(
            top: cellImageView.topAnchor,
            left: cellImageView.rightAnchor,
            paddingLeft: 8
        )
        
        mainView.addSubview(subTitleLabel)
        subTitleLabel.anchor(
            left: cellImageView.rightAnchor,
            bottom: cellImageView.bottomAnchor,
            paddingLeft: 8
        )
        
    }
    
    func configure(for item: Item) {
        cellImageView.image = repository.getImageFromFilesystem(item: item)
        titleLabel.text = item.label
        subTitleLabel.text = repository.getDetailValue(item: item, property: "species_name")
        
        if repository.didSubmitToday(for: item) {
            statusCircle.backgroundColor = .systemGreen
            countLabel.text = String(repository.getTodaysUserPhotos(for: item).count)
        } else {
            statusCircle.backgroundColor = .systemRed
            countLabel.text = ""
        }
    }
    
}
