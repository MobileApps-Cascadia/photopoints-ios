////
////  ItemMapper.swift
////  PhotoPoints
////
////  Created by Clay Suttner on 9/4/21.
////  Copyright © 2021 Cascadia College. All rights reserved.
////
//
//import CoreData
//import Foundation
//
//
//
//struct ItemMapper {
//    static let repository = Repository.instance
//
//
//    private static func makeItem(from codable: ItemCodable) -> Item {
//        repository.deleteItem(with: codable.id)
//
//        let item = Item(context: repository.context)
//
//        item.enabled = codable.enabled
//        item.id = codable.id
//        item.label = codable.label
//        item.type = codable.type
//        item.url = codable.url
//
//        addCoordinate(to: item, context: repository.context, coordinateCodable: codable.location)
//        codable.details.forEach { addDetail(to: item, context: repository.context, property: $0, value: $1) }
//        codable.images.forEach { addImage(to: item, context: repository.context, imageCodable: $0) }
//
//        repository.saveContext()
//
//        return item
//    }
//
//    private static func addCoordinate(to item: Item, context: NSManagedObjectContext, coordinateCodable: CoordinateCodable) {
//        let coordinate = Coordinate(context: context)
//
//        coordinate.item = item
//        coordinate.altitude = coordinateCodable.altitude
//        coordinate.latitude = coordinateCodable.latitude
//        coordinate.longitude = coordinateCodable.longitude
//    }
//
//    private static func addDetail(to item: Item, context: NSManagedObjectContext, property: String, value: String) {
//        let detail = Detail(context: context)
//
//        detail.item = item
//        detail.property = property
//        detail.value = value
//    }
//
//    private static func addImage(to item: Item, context: NSManagedObjectContext, imageCodable: ImageCodable) {
//        let image = Image(context: context)
//
//        image.item = item
//        image.basefile = imageCodable.basefile
//        image.desc = imageCodable.desc
//        image.filename = imageCodable.filename
//        image.license = imageCodable.license
//        image.title = imageCodable.title
//        image.imageType = ImageType(description: imageCodable.imageType).rawValue
//    }
//
//    static func dictionary(for item: Item) -> [String: Any]? {
//        let detailDict = getDetailDict(for: item)
//        let imagesCodable = getImagesCodable(for: item)
//        let location = getCoordinateCodable(for: item)
//
//        guard let id = item.id,
//              let label = item.label,
//              let itemType = item.type,
//              let url = item.url,
//              let coordinate = location
//        else {
//            return nil
//        }
//
//        let itemCodable = ItemCodable(
//            enabled: item.enabled,
//            id: id,
//            label: label,
//            type: itemType,
//            url: url,
//            details: detailDict,
//            images: imagesCodable,
//            location: coordinate)
//
//        return itemCodable.dictionary
//    }
//
//    private static func getDetailDict(for item: Item) -> [String: String] {
//        var detailDict = [String: String]()
//
//        item.details?.allObjects.forEach { detail in
//            if  let detail = detail as? Detail,
//                let property = detail.property,
//                let value = detail.value {
//
//                detailDict[property] = value
//            }
//        }
//
//        return detailDict
//    }
//
//    private static func getImagesCodable(for item: Item) -> [ImageCodable] {
//        let images = item.images?.allObjects.compactMap { $0 as? Image } ?? []
//
//        return images.compactMap { image -> ImageCodable? in
//            if  let basefile = image.basefile,
//                let filename = image.filename,
//                let fileformat = image.fileformat {
//
//                return ImageCodable(
//                    basefile: basefile,
//                    desc: image.desc,
//                    filename: filename,
//                    fileformat: fileformat,
//                    license: image.license,
//                    title: image.title,
//                    imageType: ImageType(rawValue: image.imageType)?.description ?? "unknown")
//            } else {
//                return nil
//            }
//        }
//    }
//
//    private static func getCoordinateCodable(for item: Item) -> CoordinateCodable? {
//        if  let altitude = item.location?.altitude,
//            let latitude = item.location?.latitude,
//            let longitude = item.location?.longitude {
//
//            return CoordinateCodable(
//                altitude: altitude,
//                latitude: latitude,
//                longitude: longitude)
//        } else {
//            return nil
//        }
//    }
//}
