//
//  PlantDetailView.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 4/24/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import Foundation
import UIKit

class PlantDetailView: UIViewController {
    
    // MARK: - Properties
    
    var thisPlant: PlantItem
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: thisPlant.image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // all of the text underneath the image
    lazy var infoStack: UIStackView = {

        // main stack
        let infoStack = UIStackView()
        infoStack.axis = .vertical
        infoStack.spacing = 25
        
        // my plant's story label
        let mps = PlantDetailLabel(string: "My Plant's Story")
        mps.font = UIFont.preferredFont(forTextStyle: .title1)
        infoStack.addArrangedSubview(mps)
        
        // site and enthnobotanic info label
        let siteLabel = PlantDetailLabel(string: "Site \(thisPlant.site)\nEthnobotanic Information")
        siteLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        infoStack.addArrangedSubview(siteLabel)
        
        // PNW label
        let pnwLabel = PlantDetailLabel(string: "From Plants of the Pacific Northwest Coast:")
        pnwLabel.font = UIFont.italicSystemFont(ofSize: 20)
        infoStack.addArrangedSubview(pnwLabel)
        
        // story
        let path = Bundle.main.path(forResource: "\(thisPlant.id)_story", ofType: "txt")
        
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
        let categoryBotanical = PlantDetailLabel(string: "Botanical Name")
        let dataBotanical = PlantDetailLabel(string: thisPlant.botanicalName)
        let botanicalStack = PlantDetailStack(arrangedSubviews: [categoryBotanical, dataBotanical])
        infoStack.addArrangedSubview(botanicalStack)
        
        // category (optional)
        if let category = thisPlant.category {
            let categoryCategory = PlantDetailLabel(string: "Category")
            let dataCategory = PlantDetailLabel(string: category)
            let categoryStack = PlantDetailStack(arrangedSubviews: [categoryCategory, dataCategory])
            infoStack.addArrangedSubview(categoryStack)
        }
        
        // family (optional)
        if let family = thisPlant.family {
            let categoryFamily = PlantDetailLabel(string: "Family")
            let dataFamily = PlantDetailLabel(string: family)
            let familyStack = PlantDetailStack(arrangedSubviews: [categoryFamily, dataFamily])
            infoStack.addArrangedSubview(familyStack)
        }
        
        // status
        let categoryStatus = PlantDetailLabel(string: "Status")
        let dataStatus = PlantDetailLabel(string: thisPlant.status)
        let statusStack = PlantDetailStack(arrangedSubviews: [categoryStatus, dataStatus])
        infoStack.addArrangedSubview(statusStack)
        
        return infoStack
    }()
    
    // MARK: - Init
    
    init(plantItem: PlantItem) {
        self.thisPlant = plantItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "pp-background")
        title = thisPlant.commonName
        setUpScrollView()
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
        
        scrollView.addSubview(infoStack)
        infoStack.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
    }
    
}

// saves us some repitition above by allowing us to set the properties
// seen in our custom init below
class PlantDetailLabel: UILabel {
    
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
class PlantDetailStack: UIStackView {

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
