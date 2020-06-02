//
//  MockDatabase.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 4/24/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Realm

class MockDatabase {
    
    // MARK: - New Model
    
    static let items: [Item] = [
        Item(id: 28097, point: Point(id: 28097, location: Coordinate(latitude: 47.75036, longitude: -122.191449, altitude: 0), label: "Pacific Willow", enabled: true), detail: ["common_names" : "Pacific Willow, Yellow Willow, Waxy Willow", "botanical_name" : "Salix lucida ssp. Lasiandra", "site" : "2", "category" : "Deciduous, Tree", "family" : ""], images: [Image(id: 28097, fileName: "0de693ef54a38b1224975fad7cac4e39", imageType: .full, imageHeading: "", imageLicense: "")]),
        Item(id: 28069, point: Point(id: 28069, location: Coordinate(latitude: 47.774845, longitude: -122.191508, altitude: 0), label: "Black Twinberry", enabled: true), detail: ["common_names" : "Black Twinberry, Bearberry Honeysuckle, Twinberry, Bush Honeysuckle", "botanical_name" : "Lonicera Involucrata", "site" : "2", "category" : "Berry, Deciduous, Perennial, Shrub, Woody Ornamental", "family" : "Caprifoliaceae"], images: [Image(id: 28069, fileName: "2d68e05603faeb2f249b62358f9c9495", imageType: .full, imageHeading: "", imageLicense: "")]),
        Item(id: 28092, point: Point(id: 28092, location: Coordinate(latitude: 47.774827, longitude: -122.191787, altitude: 0), label: "Douglas-Fir", enabled: true), detail: ["common_names" : "Douglas-Fir", "botanical_name" : "Pseudotsuga Menziesii", "site" : "1", "category" : "Conifer, Evergreen, Perennial, Tree", "family" : "Pinaceae"], images: [Image(id: 28092, fileName: "cecc9ccdea496978e3f7694aacebd355", imageType: .full, imageHeading: "", imageLicense: "")]),
        Item(id: 28061, point: Point(id: 28061, location: Coordinate(latitude: 47.774964, longitude: -122.191792, altitude: 0), label: "Mock-Orange", enabled: true), detail: ["common_names" : "Mock-Orange", "botanical_name" : "Philadelphus Lewisii", "site" : "1", "category" : "Deciduous, Perennial, Shrub, Woody Ornamental", "family" : ""], images: [Image(id: 28061, fileName: "a2918c4529b510e0026f4fd915dbd636", imageType: .full, imageHeading: "", imageLicense: "")]),
        Item(id: 28074, point: Point(id: 28074, location: Coordinate(latitude: 47.775134, longitude: -122.191787, altitude: 0), label: "Western Red Cedar", enabled: true), detail: ["common_names" : "Western Red Cedar", "botanical_name" : "Thuja Plicata", "site" : "3", "category" : "Conifer, Evergreen, Perennial, Tree", "family" : "Cupressaceae"], images: [Image(id: 28074, fileName: "4cec57010423a872c7318d37bc0e410e", imageType: .full, imageHeading: "", imageLicense: "")]),
        Item(id: 28070, point: Point(id: 28070, location: Coordinate(latitude: 47.774845, longitude: -122.19154, altitude: 0), label: "Clustered Wild Rose", enabled: true), detail: ["common_names" : "Clustered Wild Rose", "botanical_name" : "Rosa Pisocarpa", "site" : "2", "category" : "Deciduous, Fruit, Perennial, Shrub, Woody Ornamental", "family" : "Rosaceae"], images: [Image(id: 28070, fileName: "d8e413f9d69de4587698261c71fca7e4", imageType: .full, imageHeading: "", imageLicense: "")]),
        Item(id: 28068, point: Point(id: 28068, location: Coordinate(latitude: 47.774787, longitude: -122.191583, altitude: 0), label: "Snowberry", enabled: true), detail: ["common_names" : "Snowberry", "botanical_name" : "Symphoricarpos Albus", "site" : "2", "category" : "Berry, Deciduous, Perennial, Shrub, Woody Ornamental", "family" : "Caprifoliaceae"], images: [Image(id: 28068, fileName: "f9dc72761288eca63d189b8d06410777", imageType: .full, imageHeading: "", imageLicense: "")]),
        Item(id: 28094, point: Point(id: 28094, location: Coordinate(latitude: 47.774797, longitude: -122.191787, altitude: 0), label: "Low Oregon Grape", enabled: true), detail: ["common_names" : "Low Oregon Grape", "botanical_name" : "Mahonia Nervosa", "site" : "1", "category" : "", "family" : ""], images: [Image(id: 28094, fileName: "62bd59d3612158ed21d78be9477fa4fa", imageType: .full, imageHeading: "", imageLicense: "")]),
        Item(id: 28063, point: Point(id: 28063, location: Coordinate(latitude: 47.774865, longitude: -122.191717, altitude: 0), label: "Pacific Ninebark", enabled: true), detail: ["common_names" : "Pacific Ninebark", "botanical_name" : "Physocarpus capitatus", "site" : "1", "category" : "Deciduous, Perennial, Shrub, Woody Ornamental", "family" : ""], images: [Image(id: 28063, fileName: "505dc2d1951a9e93e0d3c93378e82e67", imageType: .full, imageHeading: "", imageLicense: "")]),
        Item(id: 28075, point: Point(id: 28075, location: Coordinate(latitude: 47.774897, longitude: -122.19191, altitude: 0), label: "Cascara", enabled: true), detail: ["common_names" : "Cascara", "botanical_name" : "Frangula purshiana", "site" : "3", "category" : "Berry, Deciduous, Tree", "family" : ""], images: [Image(id: 28075, fileName: "70837bb2822ab2518965b970b4ea46aa", imageType: .full, imageHeading: "", imageLicense: "")]),
        Item(id: 28066, point: Point(id: 28066, location: Coordinate(latitude: 47.774947, longitude: -122.191776, altitude: 0), label: "Red Alder", enabled: true), detail: ["common_names" : "Red Alder", "botanical_name" : "Alnus rubra", "site" : "3", "category" : "Deciduous, Perennial, Tree", "family" : "Betulaceae"], images: [Image(id: 28066, fileName: "2d811c6d6634fc6eeafedde95435ef78", imageType: .full, imageHeading: "", imageLicense: "")]),
        Item(id: 28072, point: Point(id: 28072, location: Coordinate(latitude: 47.774947, longitude: -122.191508, altitude: 0), label: "Paper Birch", enabled: true), detail: ["common_names" : "Paper Birch, White Birch, Canoe Birch", "botanical_name" : "Betula papyrifera", "site" : "2", "category" : "Deciduous, Tree", "family" : ""], images: [Image(id: 28072, fileName: "25b54587a8265a3c05ecab9f93a80782", imageType: .full, imageHeading: "", imageLicense: "")]),
        Item(id: 28098, point: Point(id: 28098, location: Coordinate(latitude: 47.774851, longitude: -122.191779, altitude: 0), label: "Red Elderberry", enabled: true), detail: ["common_names" : "Red Elderberry", "botanical_name" : "Sambucus racemosa ssp. pubens", "site" : "1", "category" : "Deciduous, Fruit, Shrub, Woody Ornamental", "family" : ""], images: [Image(id: 28098, fileName: "5e58b6ebfd27a0ab7b8d9253c5a57e76", imageType: .full, imageHeading: "", imageLicense: "")]),
        Item(id: 28086, point: Point(id: 28086, location: Coordinate(latitude: 47.774872, longitude: -122.191876, altitude: 0), label: "Black Cottonwood", enabled: true), detail: ["common_names" : "Black Cottonwood", "botanical_name" : "Populus trichocarpa", "site" : "1", "category" : "Deciduous, Native to North America, Tree", "family" : "Salicaceae"], images: [Image(id: 28086, fileName: "2ea9fcb1daf6f46b1357875c986ce4d4", imageType: .full, imageHeading: "", imageLicense: "")])
    ]
    
    static let qrlookups: [QrLookup] = [
        QrLookup(id: 28097, qrCode: "https://www.plantsmap.com/plants/28097"),
        QrLookup(id: 28069, qrCode: "https://www.plantsmap.com/plants/28069"),
        QrLookup(id: 28092, qrCode: "https://www.plantsmap.com/plants/28092"),
        QrLookup(id: 28061, qrCode: "https://www.plantsmap.com/plants/28061"),
        QrLookup(id: 28074, qrCode: "https://www.plantsmap.com/plants/28074"),
        QrLookup(id: 28070, qrCode: "https://www.plantsmap.com/plants/28070"),
        QrLookup(id: 28068, qrCode: "https://www.plantsmap.com/plants/28068"),
        QrLookup(id: 28094, qrCode: "https://www.plantsmap.com/plants/28094"),
        QrLookup(id: 28063, qrCode: "https://www.plantsmap.com/plants/28063"),
        QrLookup(id: 28075, qrCode: "https://www.plantsmap.com/plants/28075"),
        QrLookup(id: 28066, qrCode: "https://www.plantsmap.com/plants/28066"),
        QrLookup(id: 28072, qrCode: "https://www.plantsmap.com/plants/28072"),
        QrLookup(id: 28098, qrCode: "https://www.plantsmap.com/plants/28098"),
        QrLookup(id: 28086, qrCode: "https://www.plantsmap.com/plants/28086")
    ]
    
}
