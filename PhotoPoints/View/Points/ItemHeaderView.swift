//
//  ItemHeaderView.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 1/1/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

class ItemHeaderView: UICollectionReusableView {
    
    let repository = Repository.instance
    
    let dateLabel = UILabel()
    
    let progressLabel = UILabel()
    
    let progressContainer = UIView()
    
    let numSurveyedLabel = UILabel()
    
    let photoPointsCapsLabel = UILabel()
    
    let progressView = UIProgressView()
    
    let photoPointsLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
        addSubViews()
        setupConstraints()
        reloadProgress()
    }
    
    func configureViews() {
        dateLabel.text = Date().headerStyle()
        dateLabel.textColor = .systemGray
        dateLabel.font = UIFont.systemFont(ofSize: 13)
        
        progressLabel.text = "Today's Progress"
        progressLabel.font = UIFont.boldSystemFont(ofSize: 22)

        progressContainer.backgroundColor = UIColor(named: "pp-trans-gray")
        progressContainer.layer.cornerRadius = 10
        
        numSurveyedLabel.textColor = .systemGreen
        numSurveyedLabel.font = UIFont.systemFont(ofSize: 20)
        
        photoPointsCapsLabel.text = "POINTS"
        photoPointsCapsLabel.textColor = .systemGreen
        photoPointsCapsLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        progressView.tintColor = .systemGreen

        photoPointsLabel.text = "PhotoPoints"
        photoPointsLabel.font = UIFont.boldSystemFont(ofSize: 22)
    }
    
    func addSubViews() {
        addSubview(dateLabel)
        addSubview(progressLabel)
        addSubview(progressContainer)
        progressContainer.addSubview(numSurveyedLabel)
        progressContainer.addSubview(photoPointsCapsLabel)
        progressContainer.addSubview(progressView)
        addSubview(photoPointsLabel)
    }
    
    func setupConstraints() {
        dateLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 82, paddingLeft: 16)
        
        progressLabel.anchor(top: dateLabel.bottomAnchor, left: leftAnchor, paddingTop: 58, paddingLeft: 16)
        
        progressContainer.anchor(top: progressLabel.bottomAnchor, left: leftAnchor, bottom: photoPointsLabel.topAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        
        numSurveyedLabel.anchor(top: progressContainer.topAnchor, left: progressContainer.leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        photoPointsCapsLabel.anchor(left: numSurveyedLabel.rightAnchor, bottom: numSurveyedLabel.bottomAnchor, paddingBottom: 1)
        
        progressView.anchor(top: numSurveyedLabel.bottomAnchor, left: progressContainer.leftAnchor, right: progressContainer.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16)
        
        photoPointsLabel.anchor(top: progressContainer.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 2, paddingRight: 16)
    }
    
    func reloadProgress() {
        let numPoints = repository.getItems()?.count ?? 0
        let numSubmittedItems = repository.getItemsWithSubmissionsToday().count
        let progress = Float(numSubmittedItems) / Float(numPoints)
        
        progressView.progress = progress
        numSurveyedLabel.text = "\(numSubmittedItems)/\(numPoints)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension Date {
    func headerStyle() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .full
        let dayString = String(formatter.string(from: Date()).uppercased().dropLast(6))
        return dayString
    }
}
