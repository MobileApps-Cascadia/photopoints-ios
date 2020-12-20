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
import CoreData

class MockDatabase {
    
    static var mockdb: [Item] = []
    
    static func build() {
        
        mockdb.append(Item(id: "28097", label: "Pacific Willow", coordinate: Coordinate(latitude: 47.775036, longitude: -122.191449), details: ["common_names" : "Pacific Willow, Yellow Willow, Waxy Willow", "botanical_name" : "Salix lucida ssp. Lasiandra", "site" : "2", "category" : "Deciduous, Tree", "family" : ""], image: Image(filename: "0de693ef54a38b1224975fad7cac4e39")))
        
        mockdb.append(Item(id: "28069", label: "Black Twinberry", coordinate: Coordinate(latitude: 47.774845, longitude: -122.191508), details: ["common_names" : "Black Twinberry, Bearberry Honeysuckle, Twinberry, Bush Honeysuckle",            "botanical_name" : "Lonicera Involucrata", "site" : "2", "category" : "Berry, Deciduous, Perennial, Shrub, Woody Ornamental", "family" : "Caprifoliaceae"], image: Image(filename: "2d68e05603faeb2f249b62358f9c9495")))

        mockdb.append(Item(id: "28092", label: "Douglas-Fir", coordinate: Coordinate(latitude: 47.774827, longitude: -122.191787), details: ["common_names" : "Douglas-Fir", "botanical_name" : "Pseudotsuga Menziesii", "site" : "1", "category" : "Conifer, Evergreen, Perennial, Tree", "family" : "Pinaceae"],
            image: Image(filename: "cecc9ccdea496978e3f7694aacebd355")))
        
        mockdb.append(Item(id: "28061", label: "Mock-Orange", coordinate: Coordinate(latitude: 47.774964, longitude: -122.191792), details: ["common_names" : "Mock-Orange", "botanical_name" : "Philadelphus Lewisii", "site" : "1", "category" : "Deciduous, Perennial, Shrub, Woody Ornamental","family" : ""], image: Image(filename: "a2918c4529b510e0026f4fd915dbd636")))
        
        mockdb.append(Item(id: "28074", label: "Western Red Cedar", coordinate: Coordinate(latitude: 47.775134, longitude: -122.191787), details: ["common_names" : "Western Red Cedar", "botanical_name" : "Thuja Plicata", "site" : "3", "category" : "Conifer, Evergreen, Perennial, Tree", "family" : "Cupressaceae"],
            image: Image(filename: "4cec57010423a872c7318d37bc0e410e")))
        
        mockdb.append(Item(id: "28070", label: "Clustered Wild Rose", coordinate: Coordinate(latitude: 47.774845, longitude: -122.19154), details: ["common_names" : "Clustered Wild Rose", "botanical_name" : "Rosa Pisocarpa", "site" : "2", "category" : "Deciduous, Fruit, Perennial, Shrub, Woody Ornamental", "family" : "Rosaceae"], image: Image(filename: "d8e413f9d69de4587698261c71fca7e4")))
        
        mockdb.append(Item(id: "28068", label: "Snowberry", coordinate: Coordinate(latitude: 47.774787, longitude: -122.191583), details: ["common_names" : "Snowberry", "botanical_name" : "Symphoricarpos Albus", "site" : "2", "category" : "Berry, Deciduous, Perennial, Shrub, Woody Ornamental", "family" : "Caprifoliaceae"], image: Image(filename: "f9dc72761288eca63d189b8d06410777")))
        
        mockdb.append(Item(id: "28094", label: "Low Oregon Grape", coordinate: Coordinate(latitude: 47.774797, longitude: -122.191787), details: ["common_names" : "Low Oregon Grape", "botanical_name" : "Mahonia Nervosa", "site" : "1"], image: Image(filename: "62bd59d3612158ed21d78be9477fa4fa")))
        
        mockdb.append(Item(id: "28063", label: "Pacific Ninebark", coordinate: Coordinate(latitude: 47.774865, longitude: -122.191717), details: ["common_names" : "Pacific Ninebark","botanical_name" : "Physocarpus capitatus", "site" : "1", "category" : "Deciduous, Perennial, Shrub, Woody Ornamental", "family" : ""], image: Image(filename: "505dc2d1951a9e93e0d3c93378e82e67")))
        
        mockdb.append(Item(id: "28075", label: "Cascara", coordinate: Coordinate(latitude: 47.774897, longitude: -122.19191), details: ["common_names" : "Cascara", "botanical_name" : "Frangula purshiana", "site" : "3", "category" : "Berry, Deciduous, Tree"], image: Image(filename: "70837bb2822ab2518965b970b4ea46aa")))
        
        mockdb.append(Item(id: "28066", label: "Red Alder", coordinate: Coordinate(latitude: 47.774947, longitude: -122.191776), details: ["common_names" : "Red Alder", "botanical_name" : "Alnus rubra", "site" : "3", "category" : "Deciduous, Perennial, Tree", "family" : "Betulaceae"], image: Image(filename: "2d811c6d6634fc6eeafedde95435ef78")))
        
        mockdb.append(Item(id: "28072", label: "Paper Birch", coordinate: Coordinate(latitude: 47.774947, longitude: -122.191508), details: ["common_names" : "Paper Birch, White Birch, Canoe Birch", "botanical_name" : "Betula papyrifera", "site" : "2", "category" : "Deciduous, Tree"], image: Image(filename: "25b54587a8265a3c05ecab9f93a80782")))
        
        mockdb.append(Item(id: "28098", label: "Red Elderberry", coordinate: Coordinate(latitude: 47.774851, longitude: -122.191779), details: ["common_names" : "Red Elderberry", "botanical_name" : "Sambucus racemosa ssp. pubens", "site" : "1", "category" : "Deciduous, Fruit, Shrub, Woody Ornamental"], image: Image(filename: "5e58b6ebfd27a0ab7b8d9253c5a57e76")))
        
        mockdb.append(Item(id: "28086", label: "Black Cottonwood", coordinate: Coordinate(latitude: 47.774872, longitude: -122.191876), details: ["common_names" : "Black Cottonwood", "botanical_name" : "Populus trichocarpa", "site" : "1", "category" : "Deciduous, Native to North America, Tree", "family" : "Salicaceae"],
            image: Image(filename: "2ea9fcb1daf6f46b1357875c986ce4d4")))
    }
}
