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
    
    lazy var userPhotos = repository.getTodaysUserPhotos(for: thisItem)
    
    let photoIdentifier = "Photo Identifier"
    
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
    
    let photosLabel: UILabel = {
        let label = UILabel()
        label.text = "Today's Photos"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    let photoCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        let collection = UICollectionView(frame: frame, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .systemBackground
        return collection
    }()
    
    let detailsLabel: UILabel = {
        let label = UILabel()
        label.text = "Details"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    let detailsView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
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
            if !excludedDetails.contains(detail.property!) {
                let detailTitle = DetailTitle(string: detail.property!.humanized())
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
        view.backgroundColor = .systemGray5
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
        view.backgroundColor = .systemBackground
        title = thisItem.label
        setupSubviews()
        setupCollection()
    }

    override func viewWillAppear(_ animated: Bool) {
        // change to small tile on detail view
        navigationItem.largeTitleDisplayMode = .never
        userPhotos = repository.getTodaysUserPhotos(for: thisItem)
        photoCollection.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // change back to large title on parent view
        navigationItem.largeTitleDisplayMode = .always
        
        // using alertDelegate for scanner preview of this view but not in the library
        scanDelegate?.enableScanning()

        dateViewDelegate?.fadeInDate()
    }
    
    // MARK: - Setup
    
    func setupCollection() {
        photoCollection.delegate = self
        photoCollection.dataSource = self
        photoCollection.register(PhotoCell.self, forCellWithReuseIdentifier: photoIdentifier)
    }
    
    func setupSubviews() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(imageView)
        imageView.anchor(
            top: scrollView.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: .globalPadding,
            paddingLeft: .globalPadding,
            paddingRight: .globalPadding,
            height: view.frame.height / 3
        )

        imageView.addSubview(statusPill)
        statusPill.anchor(
            top: imageView.topAnchor,
            right: imageView.rightAnchor,
            paddingTop: 8,
            paddingRight: 8,
            height: 30
        )

        let detailsLabelTop: NSLayoutYAxisAnchor
        
        if repository.didSubmitToday(for: thisItem) {
            scrollView.addSubview(photosLabel)
            photosLabel.anchor(
                top: imageView.bottomAnchor,
                left: view.leftAnchor,
                paddingTop: .globalPadding,
                paddingLeft: .globalPadding
            )
            
            scrollView.addSubview(photoCollection)
            photoCollection.anchor(
                top: photosLabel.bottomAnchor,
                left: view.leftAnchor,
                right: view.rightAnchor,
                paddingTop: 4,
                height: view.frame.height / 7
            )
            
            detailsLabelTop = photoCollection.bottomAnchor
        } else {
            detailsLabelTop = imageView.bottomAnchor
        }
        
        scrollView.addSubview(detailsLabel)
        detailsLabel.anchor(
            top: detailsLabelTop,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: .globalPadding,
            paddingLeft: .globalPadding,
            paddingRight: .globalPadding
        )
        
        detailsView.addSubview(detailsStack)
        detailsStack.pin(to: detailsView, padding: .globalPadding)

        scrollView.addSubview(detailsView)
        detailsView.anchor(
            top: detailsLabel.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 4,
            paddingLeft: .globalPadding,
            paddingRight: .globalPadding
        )

        scrollView.addSubview(aboutLabel)
        aboutLabel.anchor(
            top: detailsView.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: .globalPadding,
            paddingLeft: .globalPadding,
            paddingRight: .globalPadding
        )
 
        aboutView.addSubview(pnwLabel)
        pnwLabel.anchor(
            top: aboutView.topAnchor,
            left: aboutView.leftAnchor,
            right: aboutView.rightAnchor,
            paddingTop: .globalPadding,
            paddingLeft: .globalPadding,
            paddingRight: .globalPadding
        )
        
        aboutView.addSubview(storylabel)
        storylabel.anchor(
            top: pnwLabel.bottomAnchor,
            left: aboutView.leftAnchor,
            bottom: aboutView.bottomAnchor,
            right: aboutView.rightAnchor,
            paddingLeft: .globalPadding,
            paddingRight: .globalPadding
        )

        scrollView.addSubview(aboutView)
        aboutView.anchor(
            top: aboutLabel.bottomAnchor,
            left: view.leftAnchor,
            bottom: scrollView.bottomAnchor,
            right: view.rightAnchor,
            paddingTop: 4,
            paddingLeft: .globalPadding,
            paddingBottom: .globalPadding,
            paddingRight: .globalPadding
        )
    }
}



extension PointsDetail: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: photoIdentifier, for: indexPath) as! PhotoCell
        photoCell.setPhoto(photo: userPhotos[indexPath.row])
        return photoCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(PhotoPages(userPhotos: userPhotos, index: indexPath.row), animated: true)
    }
    
}

extension PointsDetail: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        return CGSize(width: height, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .globalPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: .globalPadding, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: .globalPadding, height: collectionView.frame.height)
    }
    
}
