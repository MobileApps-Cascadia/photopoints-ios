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

class MockDatabase {
    
    // MARK: - Mock Database
    
    static var mockdb: [Item] = []
    static var qrLookups: [Lookup] = []
    
    static func build() {
        
        mockdb.append(Item(id: "28097",
            point: Point(location: Coordinate(latitude: 47.75036, longitude: -122.191449, altitude: 0),label: "Pacific Willow"),
            details: ["common_names" : "Pacific Willow, Yellow Willow, Waxy Willow", "botanical_name" : "Salix lucida ssp. Lasiandra", "site" : "2", "category" : "Deciduous, Tree", "family" : ""],
            images: [Image(filename: "0de693ef54a38b1224975fad7cac4e39")]
            ))
        
        mockdb.append(Item(id: "28069",
            point: Point(location: Coordinate(latitude: 47.774845, longitude: -122.191508, altitude: 0), label: "Black Twinberry"),
            details: ["common_names" : "Black Twinberry, Bearberry Honeysuckle, Twinberry, Bush Honeysuckle",
                      "botanical_name" : "Lonicera Involucrata",
                      "site" : "2",
                      "category" : "Berry, Deciduous, Perennial, Shrub, Woody Ornamental",
                      "family" : "Caprifoliaceae"],
            images: [Image(filename: "2d68e05603faeb2f249b62358f9c9495")]
            ))
        
        mockdb.append(Item(id: "28092",
            point: Point(location: Coordinate(latitude: 47.774827, longitude: -122.191787, altitude: 0), label: "Douglas-Fir"),
            details: ["common_names" : "Douglas-Fir", "botanical_name" : "Pseudotsuga Menziesii",
                   "site" : "1",
                   "category" : "Conifer, Evergreen, Perennial, Tree",
                   "family" : "Pinaceae"],
            images: [Image(filename: "cecc9ccdea496978e3f7694aacebd355")]
            ))
        
        mockdb.append(Item(id: "28061",
            point: Point(location: Coordinate(latitude: 47.774964, longitude: -122.191792, altitude: 0), label: "Mock-Orange"),
            details: ["common_names" : "Mock-Orange",
                   "botanical_name" : "Philadelphus Lewisii",
                   "site" : "1",
                   "category" : "Deciduous, Perennial, Shrub, Woody Ornamental",
                   "family" : ""],
            images: [Image(filename: "a2918c4529b510e0026f4fd915dbd636")]
            ))
        
        mockdb.append(Item(id: "28074",
            point: Point(location: Coordinate(latitude: 47.775134, longitude: -122.191787, altitude: 0), label: "Western Red Cedar"),
            details: ["common_names" : "Western Red Cedar",
                   "botanical_name" : "Thuja Plicata",
                   "site" : "3",
                   "category" : "Conifer, Evergreen, Perennial, Tree",
                   "family" : "Cupressaceae"],
            images: [Image(filename: "4cec57010423a872c7318d37bc0e410e")]
            ))
        
        mockdb.append(Item(id: "28070",
            point: Point(location: Coordinate(latitude: 47.774845, longitude: -122.19154, altitude: 0), label: "Clustered Wild Rose"),
            details: ["common_names" : "Clustered Wild Rose",
                   "botanical_name" : "Rosa Pisocarpa",
                   "site" : "2",
                   "category" : "Deciduous, Fruit, Perennial, Shrub, Woody Ornamental",
                   "family" : "Rosaceae"],
            images: [Image(filename: "d8e413f9d69de4587698261c71fca7e4")]
            ))
        
        mockdb.append(Item(id: "28068",
            point: Point(location: Coordinate(latitude: 47.774787, longitude: -122.191583, altitude: 0), label: "Snowberry"),
            details: ["common_names" : "Snowberry",
                   "botanical_name" : "Symphoricarpos Albus",
                   "site" : "2",
                   "category" : "Berry, Deciduous, Perennial, Shrub, Woody Ornamental",
                   "family" : "Caprifoliaceae"],
            images: [Image(filename: "f9dc72761288eca63d189b8d06410777")]
            ))
        
        mockdb.append(Item(id: "28094",
            point: Point(location: Coordinate(latitude: 47.774797, longitude: -122.191787, altitude: 0), label: "Low Oregon Grape"),
            details: ["common_names" : "Low Oregon Grape",
                   "botanical_name" : "Mahonia Nervosa",
                   "site" : "1"],
            images: [Image(filename: "62bd59d3612158ed21d78be9477fa4fa")]
            ))
        
        mockdb.append(Item(id: "28063",
            point: Point(location: Coordinate(latitude: 47.774865, longitude: -122.191717, altitude: 0), label: "Pacific Ninebark"),
            details: ["common_names" : "Pacific Ninebark",
                   "botanical_name" : "Physocarpus capitatus",
                   "site" : "1", "category" : "Deciduous, Perennial, Shrub, Woody Ornamental", "family" : ""],
            images: [Image(filename: "505dc2d1951a9e93e0d3c93378e82e67")]
            ))
        
        mockdb.append(Item(id: "28075",
            point: Point(location: Coordinate(latitude: 47.774897, longitude: -122.19191, altitude: 0), label: "Cascara"),
            details: ["common_names" : "Cascara",
                   "botanical_name" : "Frangula purshiana",
                   "site" : "3",
                   "category" : "Berry, Deciduous, Tree"],
            images: [Image(filename: "70837bb2822ab2518965b970b4ea46aa")]
            ))
        
        mockdb.append(Item(id: "28066",
            point: Point(location: Coordinate(latitude: 47.774947, longitude: -122.191776, altitude: 0), label: "Red Alder"),
            details: ["common_names" : "Red Alder",
                   "botanical_name" : "Alnus rubra",
                   "site" : "3",
                   "category" : "Deciduous, Perennial, Tree",
                   "family" : "Betulaceae"],
            images: [Image(filename: "2d811c6d6634fc6eeafedde95435ef78")]
            ))
        
        mockdb.append(Item(id: "28072",
            point: Point(location: Coordinate(latitude: 47.774947, longitude: -122.191508, altitude: 0), label: "Paper Birch"),
            details: ["common_names" : "Paper Birch, White Birch, Canoe Birch",
                   "botanical_name" : "Betula papyrifera",
                   "site" : "2",
                   "category" : "Deciduous, Tree"],
            images: [Image(filename: "25b54587a8265a3c05ecab9f93a80782")]
            ))
        
        mockdb.append(Item(id: "28098",
            point: Point(location: Coordinate(latitude: 47.774851, longitude: -122.191779, altitude: 0), label: "Red Elderberry"),
            details: ["common_names" : "Red Elderberry",
                   "botanical_name" : "Sambucus racemosa ssp. pubens",
                   "site" : "1",
                   "category" : "Deciduous, Fruit, Shrub, Woody Ornamental"],
            images: [Image(filename: "5e58b6ebfd27a0ab7b8d9253c5a57e76")]
            ))
        
        mockdb.append(Item(id: "28086",
             point: Point(location: Coordinate(latitude: 47.774872, longitude: -122.191876, altitude: 0), label: "Black Cottonwood"),
            details: ["common_names" : "Black Cottonwood",
                   "botanical_name" : "Populus trichocarpa",
                   "site" : "1",
                   "category" : "Deciduous, Native to North America, Tree",
                   "family" : "Salicaceae"],
            images: [Image(filename: "2ea9fcb1daf6f46b1357875c986ce4d4")]
            ))

    
        qrLookups.append(contentsOf: [
            Lookup(search: "https://www.plantsmap.com/plants/28097", id: "28097"),
            Lookup(search: "https://www.plantsmap.com/plants/28069", id: "28069"),
            Lookup(search: "https://www.plantsmap.com/plants/28092", id: "28092"),
            Lookup(search: "https://www.plantsmap.com/plants/28061", id: "28061"),
            Lookup(search: "https://www.plantsmap.com/plants/28074", id: "28074"),
            Lookup(search: "https://www.plantsmap.com/plants/28070", id: "28070"),
            Lookup(search: "https://www.plantsmap.com/plants/28068", id: "28068"),
            Lookup(search: "https://www.plantsmap.com/plants/28094", id: "28094"),
            Lookup(search: "https://www.plantsmap.com/plants/28063", id: "28063"),
            Lookup(search: "https://www.plantsmap.com/plants/28075", id: "28075"),
            Lookup(search: "https://www.plantsmap.com/plants/28066", id: "28066"),
            Lookup(search: "https://www.plantsmap.com/plants/28072", id: "28072"),
            Lookup(search: "https://www.plantsmap.com/plants/28098", id: "28098"),
            Lookup(search: "https://www.plantsmap.com/plants/28086", id: "28086")
            ])
    }
}
