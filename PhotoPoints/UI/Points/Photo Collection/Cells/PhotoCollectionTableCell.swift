//
//  PhotoCollectionTableCell.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 9/3/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

class PhotoCollectionTableCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    
    func addCollection(_ collection: UICollectionViewController) {
        containerView.addSubview(collection.view)
        collection.view.pin(to: containerView)
    }
    
}
