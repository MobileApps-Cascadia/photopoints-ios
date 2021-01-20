//
//  PhotoCell.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 1/16/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    let photoView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        contentView.addSubview(photoView)
        photoView.clipsToBounds = true
        photoView.contentMode = .scaleAspectFill
        photoView.frame = contentView.frame
        photoView.layer.cornerRadius = 10
    }

    func setPhoto(photo: UserPhoto) {
        guard let hash = photo.photoHash else { return }
        guard let image = ImageManager.getImage(from: hash, in: .photos) else { return }
        photoView.image = image
    }
    
}
