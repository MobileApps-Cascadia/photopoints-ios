//
//  ProgressCell.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 1/9/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

class ProgressCell: BaseCell {
    
    let repository = Repository.instance
    
    let numSurveyedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let photoPointsCapsLabel: UILabel = {
        let label = UILabel()
        label.text = "POINTS"
        label.textColor = .systemGreen
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.tintColor = .systemGreen
        return progressView
    }()
    
    override func setupSubviews() {
        super.setupSubviews()

        mainView.addSubview(numSurveyedLabel)
        numSurveyedLabel.anchor(top: mainView.topAnchor, left: mainView.leftAnchor, paddingTop: globalPadding, paddingLeft: globalPadding)

        mainView.addSubview(photoPointsCapsLabel)
        photoPointsCapsLabel.anchor(left: numSurveyedLabel.rightAnchor, bottom: numSurveyedLabel.bottomAnchor, paddingBottom: 1)

        mainView.addSubview(progressView)
        progressView.anchor(top: numSurveyedLabel.bottomAnchor, left: mainView.leftAnchor, right: mainView.rightAnchor, paddingTop: 8, paddingLeft: globalPadding, paddingRight: globalPadding)

    }
    
    func updateProgress() {
        let numPoints = repository.getItems()?.count ?? 0
        let numSubmittedItems = repository.getItemsWithSubmissionsToday().count
        let progress = Float(numSubmittedItems) / Float(numPoints)
        
        progressView.progress = progress
        numSurveyedLabel.text = "\(numSubmittedItems)/\(numPoints)"
    }
    
}
