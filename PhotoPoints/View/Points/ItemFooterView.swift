//
//  ItemFooterView.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 1/2/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

class ItemFooterView: UICollectionReusableView {
    
    let aboutLabel: UILabel = {
        let label = UILabel()
        label.text = "About"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    let aboutContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "pp-trans-gray")
        view.layer.cornerRadius = 10
        return view
    }()
    
    let purposeTitle = ItemDetailTitle(string: "Purpose")
    
    let purposeLabel = ItemDetailLabel(string: "Encouraging users of all ages to help track phenology and health of key biotic and abiotic components of a client-overseen biome")
    
    let logoImageView: UIImageView = {
        let image = UIImage(named: "app-logo")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let versionLabel: ItemDetailTitle = {
        let label = ItemDetailTitle(string: "version 1.1 build xx")
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        constrainSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        addSubview(aboutLabel)
        aboutContainer.addSubview(purposeTitle)
        aboutContainer.addSubview(purposeLabel)
        aboutContainer.addSubview(logoImageView)
        aboutContainer.addSubview(versionLabel)
        addSubview(aboutContainer)
    }
    
    func constrainSubviews() {
        aboutLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: globalPadding, paddingLeft: globalPadding)

        purposeTitle.anchor(top: aboutContainer.topAnchor, left: aboutContainer.leftAnchor, paddingTop: globalPadding, paddingLeft: globalPadding)

        purposeLabel.anchor(top: purposeTitle.bottomAnchor, left: aboutContainer.leftAnchor, right: aboutContainer.rightAnchor, paddingTop: 4, paddingLeft: globalPadding, paddingRight: globalPadding)

        logoImageView.anchor(top: purposeLabel.bottomAnchor, left: aboutContainer.leftAnchor, right: aboutContainer.rightAnchor, paddingTop: globalPadding, paddingLeft: globalPadding, paddingRight: globalPadding, height: 100)

        versionLabel.anchor(top: logoImageView.bottomAnchor, left: aboutContainer.leftAnchor, bottom: aboutContainer.bottomAnchor, right: aboutContainer.rightAnchor, paddingTop: globalPadding, paddingLeft: globalPadding, paddingBottom: globalPadding, paddingRight: globalPadding)

        aboutContainer.anchor(top: aboutLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: globalPadding, paddingRight: globalPadding)
    }
    
}
