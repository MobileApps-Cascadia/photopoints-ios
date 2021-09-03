//
//  PointsFooterView.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 1/9/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

class FooterCell: BaseCell {

    let purposeTitle = DetailTitle(string: "Purpose")

    let purposeLabel = DetailLabel(string: "Help protect the North Creek Forest ecosystem by adding your own photos of key environmental components to the scientific record")

    let logoImageView: UIImageView = {
        let image = UIImage(named: "app-logo")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let versionLabel: DetailTitle = {
        let label = DetailTitle(string: "version 1.1 build xx")
        label.textAlignment = .center
        return label
    }()

    convenience init() {
        self.init()
        setupSubviews()
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        mainView.addSubview(purposeTitle)
        purposeTitle.anchor(
            top: mainView.topAnchor,
            left: mainView.leftAnchor,
            paddingTop: .globalPadding,
            paddingLeft: .globalPadding
        )

        mainView.addSubview(purposeLabel)
        purposeLabel.anchor(
            top: purposeTitle.bottomAnchor,
            left: mainView.leftAnchor,
            right: mainView.rightAnchor,
            paddingTop: 4,
            paddingLeft: .globalPadding,
            paddingRight: .globalPadding
        )

        mainView.addSubview(logoImageView)
        logoImageView.anchor(
            top: purposeLabel.bottomAnchor,
            left: mainView.leftAnchor,
            right: mainView.rightAnchor,
            paddingTop: .globalPadding,
            paddingLeft: .globalPadding,
            paddingRight: .globalPadding,
            height: 100
        )

        mainView.addSubview(versionLabel)
        versionLabel.anchor(
            top: logoImageView.bottomAnchor,
            left: mainView.leftAnchor,
            bottom: mainView.bottomAnchor,
            right: mainView.rightAnchor,
            paddingTop: .globalPadding,
            paddingLeft: .globalPadding,
            paddingBottom: .globalPadding,
            paddingRight: .globalPadding
        )

    }

}
