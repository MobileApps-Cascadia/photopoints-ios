//
//  SubmissionManager.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 2/3/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

// singleton class to manage submissions

class SubmissionManager {
    
    static let instance = SubmissionManager()
    
    let repository = Repository.instance
    
    var alertDelegate: AlertDelegate!
    
    var scannedItem: Item! {
        didSet {
            alertDelegate.showScannedAlert()
        }
    }
    
    var workingSubmission: Submission!
    
    private init() {}
    
    func startSubmission() {
        workingSubmission = Submission(date: Date())
        scannedItem.addToSubmissions(workingSubmission)
    }
    
    func sendSubmission() {
        repository.saveContext()
        
        // TODO: begin URL session to send to API
        
    }
    
    func savePhoto(image: UIImage) {
        let hashString = image.pngData()!.md5()

        ImageManager.storeImage(image: image, with: hashString, to: .photos)
        print("photo saved to documents with filename \(hashString)")

        self.addPhotoToSubmission(from: hashString)
    }
    
    func addPhotoToSubmission(from hash: String) {
        let url = ImageManager.getPath(for: hash, in: .photos)
        let userPhoto = UserPhoto(photoHash: hash, photoUrl: url)
        workingSubmission.addToUserPhotos(userPhoto)
        print("photo added to \(scannedItem.label!) submission with \(workingSubmission.userPhotos?.count ?? 0) photos")
    }
    
}
