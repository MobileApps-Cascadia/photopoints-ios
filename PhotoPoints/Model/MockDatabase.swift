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
    
    static let plants: [PlantItem] = [
        PlantItem(id: 28097, coords: CLLocationCoordinate2DMake(47.775036, -122.191449), commonName: "Pacific Willow", botanicalName: "Salix Lasiandra", site: 2, category: "Deciduous, Tree"),
        PlantItem(id: 28069, coords: CLLocationCoordinate2DMake(47.774845, -122.191508),commonName: "Black Twinberry", botanicalName: "Lonicera Involucrata", site: 2, category: "Berry, Deciduous, Perennial, Shrub, Woody Ornamental", family: "Caprifoliaceae"),
        PlantItem(id: 28092, coords: CLLocationCoordinate2DMake(47.774827 , -122.191787),commonName: "Douglas Fir", botanicalName: "Pseudotsuga Menziesii", site: 1, category: "Conifer, Evergreen, Perennial, Tree", family: "Pinaceae"),
        PlantItem(id: 28061, coords: CLLocationCoordinate2DMake(47.774964 , -122.191792),commonName: "Mock Orange", botanicalName: "Philadelphus Lewisii", site: 1, category: "Deciduous, Perennial, Shrub, Woody Ornamental"),
        PlantItem(id: 28074, coords: CLLocationCoordinate2DMake(47.775134 , -122.191787),commonName: "Western Redcedar", botanicalName: "Thuja Plicata", site: 3, category: "Conifer, Evergreen, Perennial, Tree", family: "Cupressaceae"),
        PlantItem(id: 28070, coords: CLLocationCoordinate2DMake(47.774845 , -122.191540),commonName: "Clustered Wild Rose", botanicalName: "Rosa Pisocarpa", site: 2, category: "Deciduous, Fruit, Perennial, Shrub, Woody Ornamental", family: "Rosaceae"),
        PlantItem(id: 28068, coords: CLLocationCoordinate2DMake(47.774787 , -122.191583),commonName: "Snowberry", botanicalName: "Symphoricarpos Albus", site: 2, category: "Berry, Deciduous, Perennial, Shrub, Woody Ornamental", family: "Caprifoliaceae"),
        PlantItem(id: 28094, coords: CLLocationCoordinate2DMake(47.774797 , -122.191787),commonName: "Low Oregon Grape", botanicalName: "Mahonia Nervosa", site: 1),
        PlantItem(id: 28063, coords: CLLocationCoordinate2DMake(47.774865 , -122.191717),commonName: "Pacific Ninebark", botanicalName: "Physocarpus capitatus", site: 1, category: "Deciduous, Perennial, Shrub, Woody Ornamental"),
        PlantItem(id: 28075, coords: CLLocationCoordinate2DMake(47.774897 , -122.191910),commonName: "Cascara", botanicalName: "Frangula purshiana", site: 3, category: "Berry, Deciduous, Tree"),
        PlantItem(id: 28072, coords: CLLocationCoordinate2DMake(47.775095 , -122.191776),commonName: "Red Alder", botanicalName: "Alnus rubra", site: 3, category: "Deciduous, Perennial, Tree", family: "Betulaceae"),
        PlantItem(id: 28066, coords: CLLocationCoordinate2DMake(47.774947 , -122.191508),commonName: "Paper Birch", botanicalName: "Betula papyrifera", site: 2, category: "Deciduous, Tree"),
        PlantItem(id: 28098, coords: CLLocationCoordinate2DMake(47.774851 , -122.191779),commonName: "Red Elderberry", botanicalName: "Sambucus pubens", site: 1, category: "Deciduous, Fruit, Shrub, Woody Ornamental"),
        PlantItem(id: 28086, coords: CLLocationCoordinate2DMake(47.774872 , -122.191876),commonName: "Black Cottonwood", botanicalName: "Populus trichocarpa", site: 1, category: "Deciduous, Native to North America, Tree", family: "Salicaceae")
    ]
    
    static func getImages() -> [UIImage] {
        var images: [UIImage] = []
        for plant in plants {
            images.append(plant.image)
        }
        return images
    }
    
    static func getCommonNames() -> [String] {
        var commonNames: [String] = []
        for plant in plants {
            commonNames.append(plant.commonName)
        }
        return commonNames
    }
    
    static func getBotanicalNames() -> [String] {
        var botanicalNames: [String] = []
        for plant in plants {
            botanicalNames.append(plant.botanicalName)
        }
        return botanicalNames
    }
    
    static func getURlStrings() -> [String] {
        var urlStrings: [String] = []
        for plant in plants {
            urlStrings.append(plant.urlString)
        }
        return urlStrings
    }
    
    static func getPlantById(plantId: Int) -> PlantItem {
        
        let thisPlant = plants.first(where: { (plant) -> Bool in
            return plant.id == plantId
        })
        
        return thisPlant!
        
    }
    
    static func getSite(plantId: Int) -> Int {
        return getPlantById(plantId: plantId).site
    }
    
    static func getCategory(plantId: Int) -> String? {
        let thisPlant = getPlantById(plantId: plantId)
        if let category = thisPlant.category {
            return category
        }
        return nil
    }
    
    static func getFamily(plantId: Int) -> String? {
        let thisPlant = getPlantById(plantId: plantId)
        if let family = thisPlant.family {
            return family
        }
        return nil
    }
    
    static func getStatus(plantId: Int) -> String {
        return getPlantById(plantId: plantId).status
    }
    
    static func getImage(plantId: Int) -> UIImage {
        return getPlantById(plantId: plantId).image
    }
    
    static func getCommonName(plantId: Int) -> String {
        return getPlantById(plantId: plantId).commonName
    }
    
    static func getBotanicalName(plantId: Int) -> String {
        return getPlantById(plantId: plantId).botanicalName
    }
    
    // could be sketchy, currently only calling when we know we have an url in the set
    static func getPlantFromURLString(urlString: String) -> PlantItem {
        
        let thisPlant = plants.first(where: { (plant) -> Bool in
            return plant.urlString == urlString
        })
        
        return thisPlant!
    }
    
}
