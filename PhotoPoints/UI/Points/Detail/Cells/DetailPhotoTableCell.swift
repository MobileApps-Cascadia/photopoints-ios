//
//  DetailPhotoTableCell.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 9/3/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

class DetailPhotoTableCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var statusPill: UIView!
    @IBOutlet weak var numPhotosLabel: UILabel!
    
    let repository = Repository.instance
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        statusPill.clipsToBounds = true
        statusPill.layer.cornerRadius = statusPill.frame.height / 2
        
        itemImageView.clipsToBounds = true
        itemImageView.layer.cornerRadius = 8        
    }
    
    func configure(for item: Item) {
        itemImageView.image = repository.getImageFromFilesystem(item: item)
        
        if repository.didSubmitToday(for: item) {
            statusPill.backgroundColor = .systemGreen
            let count = repository.getTodaysUserPhotos(for: item).count
            numPhotosLabel.text = "  \(count) photo\(count == 1 ? "" : "s") sent today  "
        } else {
            statusPill.backgroundColor = .systemRed
            numPhotosLabel.text = "  no photos sent today  "
        }
    }
    
}
