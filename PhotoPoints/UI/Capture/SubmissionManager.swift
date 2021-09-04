//
//  SubmissionManager.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 2/3/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

// singleton class to manage current submission

class SubmissionManager {
    
    let repository = Repository.instance
    var alertDelegate: AlertDelegate!
    var submission: Submission!
    
    var scannedItem: Item! {
        didSet {
            alertDelegate.showScannedAlert()
        }
    }

    // singleton setup
    static let instance = SubmissionManager()
    
    private init() {}
    
    func startSubmission() {
        submission = Submission(context: repository.context)
        submission.date = Date()
        submission.uuid = UUID()
        scannedItem.addToSubmissions(submission)
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
        let userPhoto = UserPhoto(context: repository.context)
        
        userPhoto.photoHash = hash
        userPhoto.photoUrl = url
        
        submission.addToUserPhotos(userPhoto)
        print("photo added to \(scannedItem.label!) submission with \(submission.userPhotos?.count ?? 0) photos")
    }
    
}
