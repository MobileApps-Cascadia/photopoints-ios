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
    
    var alertDelegate: AlertDelegate!
    
    var surveyState: SurveyState = .notSurveyed
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: repository.getImageFromFilesystem(item: thisItem))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let statusPill: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 15
        label.layer.borderWidth = 1
        label.clipsToBounds = true
        label.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        label.backgroundColor = .systemRed
        label.text = "  no submission today  "
        return label
    }()
    
    // all of the text underneath the image
    lazy var infoStack: UIStackView = {

        // main stack
        let infoStack = UIStackView()
        infoStack.axis = .vertical
        infoStack.spacing = 25
        
        // my plant's story label
        let mps = ItemDetailLabel(string: "My Plant's Story")
        mps.font = UIFont.preferredFont(forTextStyle: .title1)
        infoStack.addArrangedSubview(mps)
        
        // site and enthnobotanic info label
        if let site = repository.getDetailValue(item: thisItem, property: "site") {
            let siteLabel = ItemDetailLabel(string: "Site \(site)\nEthnobotanic Information")
            siteLabel.font = UIFont.preferredFont(forTextStyle: .title2)
            infoStack.addArrangedSubview(siteLabel)
        }
        
        
        // PNW label
        let pnwLabel = ItemDetailLabel(string: "From Plants of the Pacific Northwest Coast:")
        pnwLabel.font = UIFont.italicSystemFont(ofSize: 20)
        infoStack.addArrangedSubview(pnwLabel)
        
        // story
        let path = Bundle.main.path(forResource: "\(thisItem.id ?? "")_story", ofType: "txt")
        
        do {
            let story = try String(contentsOfFile: path!, encoding: .utf8)
            let storyLabel = UILabel()
            storyLabel.text = story
            storyLabel.textColor = UIColor(named: "pp-text-color")
            
            // wrap text
            storyLabel.numberOfLines = 0
            infoStack.addArrangedSubview(storyLabel)
        } catch { print("file not found") }

        // botanical name
        if let botanicalName = repository.getDetailValue(item: thisItem, property: "botanical_name") {
            let categoryBotanical = ItemDetailLabel(string: "Botanical Name")
            let dataBotanical = ItemDetailLabel(string: botanicalName)
            let botanicalStack = ItemDetailStack(arrangedSubviews: [categoryBotanical, dataBotanical])
            infoStack.addArrangedSubview(botanicalStack)
        }
        
        
        // category (optional)
        if let category = repository.getDetailValue(item: thisItem, property: "category") {
            let categoryCategory = ItemDetailLabel(string: "Category")
            let dataCategory = ItemDetailLabel(string: category)
            let categoryStack = ItemDetailStack(arrangedSubviews: [categoryCategory, dataCategory])
            infoStack.addArrangedSubview(categoryStack)
        }
        
        // family (optional)
        if let family = repository.getDetailValue(item: thisItem, property: "family") {
            let categoryFamily = ItemDetailLabel(string: "Family")
            let dataFamily = ItemDetailLabel(string: family)
            let familyStack = ItemDetailStack(arrangedSubviews: [categoryFamily, dataFamily])
            infoStack.addArrangedSubview(familyStack)
        }
        
        return infoStack
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
        setUpScrollView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // using alertDelegate for scanner preview of this view but not in the library
        if let alertDelegate = alertDelegate {
            alertDelegate.turnOffAlert()
        }
    }
    
    func setUpScrollView() {

        // make our scrollview as big as our view
        let frame = view.frame
        let scrollView = UIScrollView(frame: frame)
        view.addSubview(scrollView)
        
        // placeholder height to account for lengthiest plant stories
        // TODO: make this height adaptive to the amount of content
        scrollView.contentSize = CGSize(width: frame.width, height: 2600)
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        scrollView.addSubview(imageView)
        imageView.anchor(top: scrollView.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: frame.height * 2 / 3)
        imageView.addSubview(statusPill)
        statusPill.anchor(top: imageView.topAnchor, right: imageView.rightAnchor, paddingTop: 10, paddingRight: 10, height: 30)
        
        if repository.didSubmitToday(for: thisItem) {
            statusPill.backgroundColor = .systemGreen
            statusPill.text = "  submission sent  "
        }
        
        scrollView.addSubview(infoStack)
        infoStack.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
    }
    
}

// saves us some repitition above by allowing us to set the properties
// seen in our custom init below
class ItemDetailLabel: UILabel {
    
    init(string: String){
        
        // this frame size will be overriden below
        // have to pass in this superclass init for our override
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        text = string
        textColor = UIColor(named: "pp-text-color")
        font = UIFont.preferredFont(forTextStyle: .title3)
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
        axis = .horizontal
        alignment = .top
        distribution = .fillEqually
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
