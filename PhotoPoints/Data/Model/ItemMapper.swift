//
//  ItemMapper.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 9/4/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import CoreData
import Foundation

struct ItemMapper {
    
    private struct ItemCodable: Codable {
        let enabled: Bool
        let id: String
        let label: String
        let type: String
        let url: String
        let details: [String: String]
        let images: [ImageCodable]
        let location: CoordinateCodable
    }
    
    private struct ImageCodable: Codable {
        let basefile: String
        let desc: String?
        let filename: String
        let fileformat: String
        let license: String?
        let title: String?
        let imageType: String
    }
    
    private struct CoordinateCodable: Codable {
        let altitude: Double
        let latitude: Double
        let longitude: Double
        
        func addCoordinate(to item: Item, context: NSManagedObjectContext) {
            let coordinate = Coordinate(context: context)
            
            coordinate.item = item
            coordinate.altitude = altitude
            coordinate.latitude = latitude
            coordinate.longitude = longitude
        }
    }
    
    static let repository = Repository.instance
    
    @discardableResult
    static func map(data: Data) -> [Item] {
        do {
            let items = try JSONDecoder().decode([ItemCodable].self, from: data)
            return items.map(makeItem)
        } catch {
            print(error)
            return []
        }
    }
    
    @discardableResult
    static func map(dictionary: [String: Any]) -> Item? {
        do {
            let data = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            let itemCodable = try JSONDecoder().decode(ItemCodable.self, from: data)
            
            return makeItem(from: itemCodable)
        } catch {
            print(error)
            return nil
        }
    }
    
    private static func makeItem(from codable: ItemCodable) -> Item {
        let item = Item(context: repository.context)

        item.enabled = codable.enabled
        item.id = codable.id
        item.label = codable.label
        item.type = codable.type
        item.url = codable.url
        
        codable.location.addCoordinate(to: item, context: repository.context)
        
        codable.details.forEach { addDetail(to: item, context: repository.context, property: $0, value: $1) }
        codable.images.forEach { addImage(to: item, context: repository.context, imageCodable: $0) }
        
        print(item.label)
        
        return item
    }
    
    private static func addDetail(to item: Item, context: NSManagedObjectContext, property: String, value: String) {
        let detail = Detail(context: context)

        detail.item = item
        detail.property = property
        detail.value = value
    }
    
    private static func addImage(to item: Item, context: NSManagedObjectContext, imageCodable: ImageCodable) {
        let image = Image(context: context)
        
        image.item = item
        image.basefile = imageCodable.basefile
        image.desc = imageCodable.desc
        image.filename = imageCodable.filename
        image.license = imageCodable.license
        image.title = imageCodable.title
        image.imageType = ImageType(description: imageCodable.imageType).rawValue
    }
    
    static func dictionary(for item: Item) -> [String: Any]? {
        let detailDict = getDetailDict(for: item)
        let imagesCodable = getImagesCodable(for: item)
        let location = getCoordinateCodable(for: item)
        
        guard let id = item.id,
              let label = item.label,
              let itemType = item.type,
              let url = item.url,
              let coordinate = location
        else {
            return nil
        }
        
        let itemCodable = ItemCodable(
            enabled: item.enabled,
            id: id,
            label: label,
            type: itemType,
            url: url,
            details: detailDict,
            images: imagesCodable,
            location: coordinate)
        
        return itemCodable.dictionary
    }
    
    private static func getDetailDict(for item: Item) -> [String: String] {
        var detailDict = [String: String]()
        
        item.details?.allObjects.forEach { detail in
            if  let detail = detail as? Detail,
                let property = detail.property,
                let value = detail.value {
                
                detailDict[property] = value
            }
        }
        
        return detailDict
    }
    
    private static func getImagesCodable(for item: Item) -> [ImageCodable] {
        let images = item.images?.allObjects.compactMap { $0 as? Image } ?? []
        
        return images.compactMap { image -> ImageCodable? in
            if  let basefile = image.basefile,
                let filename = image.filename,
                let fileformat = image.fileformat {
                
                return ImageCodable(
                    basefile: basefile,
                    desc: image.desc,
                    filename: filename,
                    fileformat: fileformat,
                    license: image.license,
                    title: image.title,
                    imageType: ImageType(rawValue: image.imageType)?.description ?? "unknown")
            } else {
                return nil
            }
        }
    }
    
    private static func getCoordinateCodable(for item: Item) -> CoordinateCodable? {
        if  let altitude = item.location?.altitude,
            let latitude = item.location?.latitude,
            let longitude = item.location?.longitude {
            
            return CoordinateCodable(
                altitude: altitude,
                latitude: latitude,
                longitude: longitude)
        } else {
            return nil
        }
    }
}
