//
//  PointTableCellTableViewCell.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 9/3/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import Combine
import UIKit

class PointTableCell: UITableViewCell {

    @IBOutlet weak var pointImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var statusCircle: UIView!
    @IBOutlet weak var countLabel: UILabel!

    var imageCancellable: AnyCancellable?
    
    let repository = Repository.instance
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        pointImageView?.image = nil
        imageCancellable?.cancel()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pointImageView.clipsToBounds = true
        pointImageView.layer.cornerRadius = pointImageView.frame.height / 2
        
        statusCircle.clipsToBounds = true
        statusCircle.layer.cornerRadius = statusCircle.frame.height / 2
    }
    
    func configure(for item: Item) {
        titleLabel.text = item.label
        subtitleLabel.text = item.details.first(where: { $0.property == "species_name" })?.value
        
        setupStatusCircle(for: item)
        setImage(for: item)
    }
    
    private func setupStatusCircle(for item: Item) {
        if repository.didSubmitToday(for: item) {
            statusCircle.backgroundColor = .systemGreen
            countLabel.text = String(repository.getTodaysUserPhotos(for: item).count)
        } else {
            statusCircle.backgroundColor = .systemRed
            countLabel.text = " "
        }
    }
    
    private func setImage(for item: Item) {
        if let image = repository.getFirstImage(of: item) {
            imageCancellable = FirebaseAPIClient().getImageData(image)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] data in
                    if let data = data {
                        self?.pointImageView?.image = UIImage(data: data)
                    }
                }
        }
    }
    
}
