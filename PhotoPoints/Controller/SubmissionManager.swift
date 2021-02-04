//
//  SubmissionManager.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 2/3/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

class SubmissionManager {
    
    var scannedItem: Item!
    
    var workingSubmission: Submission!
    
    func startSubmission() {
        
    }
    
    func continueSubmission() {
        
    }
    
    func endSubmission() {
        
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
