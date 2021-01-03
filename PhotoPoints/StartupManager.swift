//
//  StartupManager.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 12/12/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import CoreData
import UIKit

class StartupManager {
    
    // get repository instance for methods requiring data retreival
    // access managed object context
    static let repository = Repository.instance
    
    static let defaults = UserDefaults.standard
    
    static func run(){
        if defaults.object(forKey: "FirstRun") == nil {
            print("performing first run")
            firstRun()
            defaults.set(false, forKey: "FirstRun")
        }
        print("performing startup")
        startup()
    }
    
    static func firstRun(){
        createImageAndPhotoDirectories()
        loadInitData()
    }
    
    static func startup(){
        storeAppConfigData()
    }
    
    static func storeAppConfigData(){
        
        defaults.set(Date(), forKey: "LastUpdated")
        
        // somewhere else in app we will have file that contains global constants - ClearOnStartup, DebugModeOn etc
        defaults.set(true, forKey: "ClearOnStartup")
        // future keys to be added:
        
        // only upload on wifi
        // API database version
        
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
    
    static func loadInitData(){
        
        print("loading initial data")
        
        // necessary to access context in some way before creating objects
        repository.context.reset()
        
        // build mock database
        MockDatabase.build()
        
        // write to core data
        do {
            try repository.context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        // load images to filesystem
        loadInitImages()
    }
    
    // load initial images from xcassets to filesystem to allow us to test getting images
    // from filesystem, as this is what we'll do for images retrieved from API.
    static func loadInitImages() {
        if let items = repository.getItems() {
            for item in items {
                if let image = repository.getImageFromXcAssets(item: item), let fileName = repository.getImageNameFromXcAssets(item: item) {
                    ImageManager.storeImage(image: image, with: fileName, to: .images)
                }
            }
        }
    }

}
