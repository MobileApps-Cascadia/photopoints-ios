//
//  ProgressTableCell.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 9/3/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

class ProgressTableCell: UITableViewCell {

    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var numSurveyedLabel: UILabel!
    
    let repository = Repository.instance

    func updateProgress() {
        let numPoints = repository.items.count
        let numSubmittedItems = repository.itemsWithSubmissionsToday.count
        let progress = Float(numSubmittedItems) / Float(numPoints)
        
        progressView.progress = progress
        numSurveyedLabel.text = "\(numSubmittedItems)/\(numPoints)"
    }
    
}
