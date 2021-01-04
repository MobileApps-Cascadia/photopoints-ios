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
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = Date().headerStyle()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let progressLabel: UILabel = {
        let label = UILabel()
        label.text = "Today's Progress"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    let progressContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "pp-trans-gray")
        view.layer.cornerRadius = 10
        return view
    }()
    
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
    
    let photoPointsLabel: UILabel = {
        let label = UILabel()
        label.text = "PhotoPoints"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    var paddingTop: CGFloat = 0
    
//    init(paddingTop: CGFloat) {
//        self.paddingTop = paddingTop
//        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//        addSubviews()
//        constrainSubviews()
//
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        constrainSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        addSubview(dateLabel)
        addSubview(progressLabel)
        addSubview(progressContainer)
        progressContainer.addSubview(numSurveyedLabel)
        progressContainer.addSubview(photoPointsCapsLabel)
        progressContainer.addSubview(progressView)
        addSubview(photoPointsLabel)
    }
    
    // called when header is dequeued
    func setHeaderPadding(headerPadding: CGFloat) {
        dateLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: headerPadding, paddingLeft: globalPadding)
    }
    
    func constrainSubviews() {
        progressLabel.anchor(top: dateLabel.bottomAnchor, left: leftAnchor, paddingTop: 58, paddingLeft: globalPadding)
        
        progressContainer.anchor(top: progressLabel.bottomAnchor, left: leftAnchor, bottom: photoPointsLabel.topAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: globalPadding, paddingBottom: globalPadding, paddingRight: globalPadding)
        
        numSurveyedLabel.anchor(top: progressContainer.topAnchor, left: progressContainer.leftAnchor, paddingTop: globalPadding, paddingLeft: globalPadding)
        
        photoPointsCapsLabel.anchor(left: numSurveyedLabel.rightAnchor, bottom: numSurveyedLabel.bottomAnchor, paddingBottom: 1)
        
        progressView.anchor(top: numSurveyedLabel.bottomAnchor, left: progressContainer.leftAnchor, right: progressContainer.rightAnchor, paddingTop: 8, paddingLeft: globalPadding, paddingRight: globalPadding)

        photoPointsLabel.anchor(top: progressContainer.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: globalPadding, paddingLeft: globalPadding, paddingBottom: 2, paddingRight: globalPadding)
    }
    
    // called when header is dequeued
    func reloadProgress() {
        let numPoints = repository.getItems()?.count ?? 0
        let numSubmittedItems = repository.getItemsWithSubmissionsToday().count
        let progress = Float(numSubmittedItems) / Float(numPoints)
        
        progressView.progress = progress
        numSurveyedLabel.text = "\(numSubmittedItems)/\(numPoints)"
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
