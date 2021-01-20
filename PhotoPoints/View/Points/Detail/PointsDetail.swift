//
//  PointsDetail.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 4/24/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import Foundation
import UIKit

class PointsDetail: UIViewController {
    
    // MARK: - Properties
    let repository = Repository.instance
    
    var thisItem: Item
    
    var scanDelegate: ScanDelegate!
    
    var dateViewDelegate: DateViewDelegate!
    
    var surveyState: SurveyState = .notSurveyed
    
    lazy var scrollView = UIScrollView(frame: view.frame)
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: repository.getImageFromFilesystem(item: thisItem))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    lazy var statusPill: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.backgroundColor = .systemRed
        label.textColor = .white
        if repository.didSubmitToday(for: thisItem) {
            label.backgroundColor = .systemGreen
            let count = repository.getTodaysUserPhotos(for: thisItem).count
            label.text = "  \(count) photo\(count == 1 ? "" : "s") sent today  "
        } else {
            label.text = "  no photos sent today  "
        }
        return label
    }()
    
    let detailsLabel: UILabel = {
        let label = UILabel()
        label.text = "Details"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    let detailsView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "pp-trans-gray")
        view.layer.cornerRadius = 10
        return view
    }()
    
    // all of the text underneath the image
    lazy var detailsStack: UIStackView = {
        
        // main stack
        let detailsStack = UIStackView()
        detailsStack.axis = .vertical
        detailsStack.spacing = 16
        
        let excludedDetails = ["common_names", "story", "short_description", "full_description"]
        let details = repository.getDetails(for: thisItem)
        
        for detail in details {
            if !excludedDetails.contains(detail.property) {
                let detailTitle = DetailTitle(string: detail.property.humanized())
                let detailLabel = DetailLabel(string: detail.value ?? "no value")
                let detailStack = DetailStack(arrangedSubviews: [detailTitle, detailLabel])
                detailsStack.addArrangedSubview(detailStack)
            }
        }
        
        return detailsStack
    }()
    
    let aboutLabel: UILabel = {
        let label = UILabel()
        label.text = "About"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    let aboutView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "pp-trans-gray")
        view.layer.cornerRadius = 10
        return view
    }()
    
    // PNW label
    let pnwLabel = DetailTitle(string: "From Plants of the Pacific Northwest Coast")
    
    lazy var storylabel: DetailLabel = {
        let story = repository.getDetailValue(item: thisItem, property: "story") ?? ""
        let label = DetailLabel(string: story)
        // wrap text
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Init
    
    init(item: Item) {
        self.thisItem = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "pp-background")
        title = thisItem.label
        addSubviews()
        constrainSubviews()
    }

    override func viewWillAppear(_ animated: Bool) {
        // change to small tile on detail view
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // change back to large title on parent view
        navigationItem.largeTitleDisplayMode = .always
        
        // using alertDelegate for scanner preview of this view but not in the library
        if let scanDelegate = scanDelegate {
            scanDelegate.enableScanning()
        }

        dateViewDelegate?.fadeInDate()
    }
    
    func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        imageView.addSubview(statusPill)
        scrollView.addSubview(detailsLabel)
        detailsView.addSubview(detailsStack)
        scrollView.addSubview(detailsView)
        scrollView.addSubview(aboutLabel)
        aboutView.addSubview(pnwLabel)
        aboutView.addSubview(storylabel)
        scrollView.addSubview(aboutView)
    }
    
    // MARK: - Setup
    
    func constrainSubviews() {
        imageView.anchor(top: scrollView.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: globalPadding, paddingLeft: globalPadding, paddingRight: globalPadding, height: view.frame.height / 3)

        statusPill.anchor(top: imageView.topAnchor, right: imageView.rightAnchor, paddingTop: 8, paddingRight: 8, height: 30)

        detailsLabel.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: globalPadding, paddingLeft: globalPadding, paddingRight: globalPadding)

        detailsStack.anchor(top: detailsView.topAnchor, left: detailsView.leftAnchor, bottom: detailsView.bottomAnchor, right: detailsView.rightAnchor, paddingTop: globalPadding, paddingLeft: globalPadding, paddingBottom: globalPadding, paddingRight: globalPadding)

        detailsView.anchor(top: detailsLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 4, paddingLeft: globalPadding, paddingRight: globalPadding)

        aboutLabel.anchor(top: detailsView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: globalPadding, paddingLeft: globalPadding, paddingRight: globalPadding)
 
        pnwLabel.anchor(top: aboutView.topAnchor, left: aboutView.leftAnchor, right: aboutView.rightAnchor, paddingTop: globalPadding, paddingLeft: globalPadding, paddingRight: globalPadding)

        storylabel.anchor(top: pnwLabel.bottomAnchor, left: aboutView.leftAnchor, bottom: aboutView.bottomAnchor, right: aboutView.rightAnchor, paddingLeft: globalPadding, paddingRight: globalPadding)

        aboutView.anchor(top: aboutLabel.bottomAnchor, left: view.leftAnchor, bottom: scrollView.bottomAnchor, right: view.rightAnchor, paddingTop: 4, paddingLeft: globalPadding, paddingBottom: globalPadding, paddingRight: globalPadding)
    }
}

extension String {
    func humanized() -> String {
        return self.replacingOccurrences(of: "_", with: " ").capitalized
    }
}
