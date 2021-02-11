//
//  ItemAnnotationView.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 2/6/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import MapKit

//Enum for changing map marker states
enum SurveyState {
    case notSurveyed
    case surveyed
    case mix
}

class ItemAnnotationView: MKAnnotationView {
    
    let repository = Repository.instance
    
    var annotations = [MKAnnotation?]()

    let stateColor: [SurveyState : UIColor] = [
        .notSurveyed : .systemRed,
        .surveyed : .systemGreen,
        .mix : .systemYellow
    ]
    
    init(annotation: MKAnnotation) {
        super.init(annotation: annotation, reuseIdentifier: "item")
        configure()
        setAnnotations()
        setImages()
        setColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        clusteringIdentifier = "cluster"
        collisionMode = .circle
        canShowCallout = true
    }
    
    func setAnnotations() {
        if annotation is MKClusterAnnotation {
            annotations = (annotation as! MKClusterAnnotation).memberAnnotations
        } else {
            annotations = [annotation]
        }
    }
    
    func setImages() {
        var borderImage: UIImage
        var numberImage: UIImage
        var fillImage: UIImage
        let count = annotations.count
        let configuration = UIImage.SymbolConfiguration(font: .systemFont(for: count))
        
        borderImage = UIImage(systemName: "circle.fill", withConfiguration: configuration)!
        numberImage = UIImage(systemName: "\(count).circle.fill", withConfiguration: configuration)!
        fillImage = count == 1 ? borderImage : numberImage
        
        image = borderImage
        addSubview(UIImageView(image: fillImage))
    }
    
    func setColor() {
        var didSubmit = [Bool]()
        var surveyState: SurveyState = .notSurveyed
        
        for annotation in annotations {
            let item = (annotation as! ItemAnnotation).item
            didSubmit.append(repository.didSubmitToday(for: item))
            (annotation as! ItemAnnotation).updatePhotoCount()
        }
        
        if didSubmit.contains(false) && didSubmit.contains(true) {
            surveyState = .mix
        }
        
        if !didSubmit.contains(false) {
            surveyState = .surveyed
        }
        
        tintColor = stateColor[surveyState]
    }
    
}

extension UIFont {
    
    //map marker font size
    static func systemFont(for count: Int) -> UIFont {
        let size = CGFloat(pow(Double(count), 1 / 3) * 25)
        return UIFont.systemFont(ofSize: size)
    }
    
}
