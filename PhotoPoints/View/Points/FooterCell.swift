//
//  PointsFooterView.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 1/9/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

class TableFooter: UIView {
    
    let aboutContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "pp-trans-gray")
        view.layer.cornerRadius = 10
        return view
    }()

    let purposeTitle = ItemDetailTitle(string: "Purpose")

    let purposeLabel = ItemDetailLabel(string: "Help protect the North Creek Forest biome by adding your own photos of key environmental components to the scientific record")

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

    func setupSubviews() {
        addSubview(aboutContainer)
        aboutContainer.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 2, paddingLeft: globalPadding, paddingRight: globalPadding)
        
        aboutContainer.addSubview(purposeTitle)
        purposeTitle.anchor(top: aboutContainer.topAnchor, left: aboutContainer.leftAnchor, paddingTop: globalPadding, paddingLeft: globalPadding)

        aboutContainer.addSubview(purposeLabel)
        purposeLabel.anchor(top: purposeTitle.bottomAnchor, left: aboutContainer.leftAnchor, right: aboutContainer.rightAnchor, paddingTop: 4, paddingLeft: globalPadding, paddingRight: globalPadding)

        aboutContainer.addSubview(logoImageView)
        logoImageView.anchor(top: purposeLabel.bottomAnchor, left: aboutContainer.leftAnchor, right: aboutContainer.rightAnchor, paddingTop: globalPadding, paddingLeft: globalPadding, paddingRight: globalPadding, height: 100)

        aboutContainer.addSubview(versionLabel)
        versionLabel.anchor(top: logoImageView.bottomAnchor, left: aboutContainer.leftAnchor, bottom: aboutContainer.bottomAnchor, right: aboutContainer.rightAnchor, paddingTop: globalPadding, paddingLeft: globalPadding, paddingBottom: globalPadding, paddingRight: globalPadding)

    }

}
