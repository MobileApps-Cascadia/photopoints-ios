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
    
    let stateColor: [SurveyState : UIColor] = [
        .notSurveyed : .systemRed,
        .surveyed : .systemGreen,
        .mix : .systemYellow
    ]
    
    init(annotation: MKAnnotation) {
        super.init(annotation: annotation, reuseIdentifier: "item")
        
        clusteringIdentifier = "cluster"
        collisionMode = .circle
        canShowCallout = true

        var didSubmit = [Bool]()
        var annotations: [MKAnnotation]
        var configuration: UIImage.SymbolConfiguration
        
        if annotation is MKClusterAnnotation {
            annotations = (annotation as! MKClusterAnnotation).memberAnnotations
        } else {
            annotations = [annotation]
        }
        
        let count = annotations.count
        var borderImage: UIImage
        var numberImage: UIImage
        var fillImage: UIImage
        
        configuration = UIImage.SymbolConfiguration(font: fontSize(for: count))
        borderImage = UIImage(systemName: "circle.fill", withConfiguration: configuration)!
        numberImage = UIImage(systemName: "\(count).circle.fill", withConfiguration: configuration)!
        fillImage = count == 1 ? borderImage : numberImage
        
        for annotation in annotations {
            let item = (annotation as! ItemAnnotation).item
            didSubmit.append(repository.didSubmitToday(for: item))
            (annotation as! ItemAnnotation).updatePhotoCount()
        }
        
        var surveyState: SurveyState = .notSurveyed
        
        if didSubmit.contains(false) && didSubmit.contains(true) {
            surveyState = .mix
        }
        
        if !didSubmit.contains(false) {
            surveyState = .surveyed
        }
        
        tintColor = stateColor[surveyState]
        image = borderImage
        addSubview(UIImageView(image: fillImage))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
