//
//  PlantDetailView.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 4/24/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import Foundation
import UIKit

class ItemDetailView: UIViewController {
    
    // MARK: - Properties
    let repository = Repository.instance
    
    var thisItem: Item
    
    var scanDelegate: ScanDelegate!
    
    var surveyState: SurveyState = .notSurveyed
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.frame)
        
        // placeholder height to account for lengthiest plant stories
        // TODO: make this height adaptive to the amount of content
        scrollView.contentSize = CGSize(width: view.frame.width, height: 1421)
        return scrollView
    }()
    
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
        
        // botanical name
        if let botanicalName = repository.getDetailValue(item: thisItem, property: "botanical_name") {
            let categoryBotanical = ItemDetailTitle(string: "Botanical Name")
            let dataBotanical = ItemDetailLabel(string: botanicalName)
            let botanicalStack = ItemDetailStack(arrangedSubviews: [categoryBotanical, dataBotanical])
            detailsStack.addArrangedSubview(botanicalStack)
        }
        
        // category (optional)
        if let category = repository.getDetailValue(item: thisItem, property: "category") {
            let categoryCategory = ItemDetailTitle(string: "Category")
            let dataCategory = ItemDetailLabel(string: category)
            let categoryStack = ItemDetailStack(arrangedSubviews: [categoryCategory, dataCategory])
            detailsStack.addArrangedSubview(categoryStack)
        }
        
        // family (optional)
        if let family = repository.getDetailValue(item: thisItem, property: "family") {
            let categoryFamily = ItemDetailTitle(string: "Family")
            let dataFamily = ItemDetailLabel(string: family)
            let familyStack = ItemDetailStack(arrangedSubviews: [categoryFamily, dataFamily])
            detailsStack.addArrangedSubview(familyStack)
        }
        
        // site and enthnobotanic info label
        if let site = repository.getDetailValue(item: thisItem, property: "site") {
            let categorySite = ItemDetailTitle(string: "Site")
            let dataSite = ItemDetailLabel(string: site)
            let siteStack = ItemDetailStack(arrangedSubviews: [categorySite, dataSite])
            detailsStack.addArrangedSubview(siteStack)
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
    let pnwLabel = ItemDetailTitle(string: "From Plants of the Pacific Northwest Coast")
    
    lazy var storylabel: ItemDetailLabel = {
        // story
        var story = String()
        
        let path = Bundle.main.path(forResource: "\(thisItem.id ?? "")_story", ofType: "txt")

        do {
            story = try String(contentsOfFile: path!, encoding: .utf8)
        } catch {
            print("file not found")
        }
        let label = ItemDetailLabel(string: story)
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
        
        // using alertDelegate for scanner preview of this view but not in the library
        if let scanDelegate = scanDelegate {
            scanDelegate.enableScanning()
        }
        
        // change back to large title on parent view
        navigationItem.largeTitleDisplayMode = .always
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
    
    func constrainSubviews() {
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)

        imageView.anchor(top: scrollView.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: globalPadding, paddingLeft: globalPadding, paddingRight: globalPadding, height: view.frame.height / 3)

        statusPill.anchor(top: imageView.topAnchor, right: imageView.rightAnchor, paddingTop: 8, paddingRight: 8, height: 30)

        detailsLabel.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: globalPadding, paddingLeft: globalPadding, paddingRight: globalPadding)

        detailsStack.anchor(top: detailsView.topAnchor, left: detailsView.leftAnchor, bottom: detailsView.bottomAnchor, right: detailsView.rightAnchor, paddingTop: globalPadding, paddingLeft: globalPadding, paddingBottom: globalPadding, paddingRight: globalPadding)

        detailsView.anchor(top: detailsLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 4, paddingLeft: globalPadding, paddingRight: globalPadding)

        aboutLabel.anchor(top: detailsView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: globalPadding, paddingLeft: globalPadding, paddingRight: globalPadding)
 
        pnwLabel.anchor(top: aboutView.topAnchor, left: aboutView.leftAnchor, right: aboutView.rightAnchor, paddingTop: globalPadding, paddingLeft: globalPadding, paddingRight: globalPadding)

        storylabel.anchor(top: pnwLabel.bottomAnchor, left: aboutView.leftAnchor, right: aboutView.rightAnchor, paddingLeft: globalPadding, paddingRight: globalPadding)

        aboutView.anchor(top: aboutLabel.bottomAnchor, left: view.leftAnchor, bottom: storylabel.bottomAnchor, right: view.rightAnchor, paddingTop: 4, paddingLeft: globalPadding, paddingBottom: -globalPadding!, paddingRight: globalPadding)
    }
}

// saves us some repitition above by allowing us to set the properties
// seen in our custom init below

class ItemDetailTitle: UILabel {
    
    init(string: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        text = string
        textColor = UIColor(named: "pp-text-color")
        font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        self.sizeToFit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ItemDetailLabel: UILabel {
    
    init(string: String) {
        
        // this frame size will be overriden below
        // have to pass in this superclass init for our override
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        text = string
        textColor = UIColor(named: "pp-secondary-text-color")
        font = UIFont.systemFont(ofSize: 19, weight: .regular)
        numberOfLines = 0
        
        // override frame above, size the label to fit text
        self.sizeToFit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// saves us some repitition above by allowing us to set the properties
// seen in the overriden init below
class ItemDetailStack: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        alignment = .top
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
