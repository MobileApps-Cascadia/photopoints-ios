//
//  PointTableCellTableViewCell.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 9/3/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

class PointTableCell: UITableViewCell {

    @IBOutlet weak var pointImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var statusCircle: UIView!
    @IBOutlet weak var countLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        pointImageView.clipsToBounds = true
        pointImageView.layer.cornerRadius = pointImageView.frame.height / 2
        
        statusCircle.clipsToBounds = true
        statusCircle.layer.cornerRadius = statusCircle.frame.height / 2
    }
    
    func configure(for item: Item) {
        let repository = Repository.instance
        
        pointImageView.image = repository.getImageFromFilesystem(item: item)
        titleLabel.text = item.label
        subtitleLabel.text = repository.getDetailValue(item: item, property: "species_name")
        
        if repository.didSubmitToday(for: item) {
            statusCircle.backgroundColor = .systemGreen
            countLabel.text = String(repository.getTodaysUserPhotos(for: item).count)
        } else {
            statusCircle.backgroundColor = .systemRed
            countLabel.text = " "
        }
    }
    
}
