//
//  StartupManager.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 12/12/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import Foundation

class StartupManager {
    
    static func run(){
        createImageAndPhotoDirectories()
        Repository.instance.loadInitData()
    }
    
    // add image and photo subdirectories to .documents
    static func createImageAndPhotoDirectories(){
        let fm = FileManager.default
        if let documentURL = fm.urls(for: .documentDirectory, in: .userDomainMask).first {
            let imagesURL = documentURL.appendingPathComponent(SubDirectory.images.rawValue)
            let photosURL = documentURL.appendingPathComponent(SubDirectory.photos.rawValue)
            do {
                try fm.createDirectory(at: imagesURL, withIntermediateDirectories: true, attributes: nil)
                try fm.createDirectory(at: photosURL, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("error creating subdirectory: \(error.localizedDescription)")
            }
        }
    }
    
}
