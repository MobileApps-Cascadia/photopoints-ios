//
//  ScannerView.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 4/7/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import UIKit
import AVFoundation
import CryptoKit

// code modified from https://www.youtube.com/watch?v=4Zf9dHDJ2yU
class CaptureView: UIViewController, ScannedItemDelegate {
    
    // MARK: - Properties
    
    let repository = Repository.instance

    // video session: optional because we won't have it in our emulator
    var scanSession: QrScanningSession!
    
    // photo capture view
    let imagePicker = ImagePickerWithScanDelegate()
    
    // these variables won't be referenced until they are assigned values
    var workingSubmission: Submission!
    var scannedItem: Item! {
        didSet {
            showScannedAlert()
        }
    }

    let scannerSquare: UIView = {
        let square = UIView()
        square.layer.borderWidth = 2
        square.layer.borderColor = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1)
        square.layer.cornerRadius = 10
        return square
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        setup()
    }
    
    // terminate the session if we navigate off this view
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scanSession?.stopRunning()
    }
    
    // bring the session up again if we switch back to this view
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scanSession?.startRunning()
    }
    
    // MARK: - Scanner
    
    func setup() {
        if let session = QrScanningSession(in: view) {
            scanSession = session
            scanSession.itemDelegate = self
            addScannerSquare()
            setupImagePicker()
        } else {
            addNoAVDLabel()
        }
    }
    
    // MARK: - View Setup
    
    func configureNavBar() {
        navigationController?.navigationBar.topItem?.title = "Center QR Code in Square"
    }
    
    func addScannerSquare() {
        view.addSubview(scannerSquare)
        let width = view.frame.width - globalPadding! * 2
        scannerSquare.anchor(
            centerX: view.centerXAnchor,
            centerY: view.centerYAnchor,
            width: width,
            height: width
        )
    }
    
    func addNoAVDLabel() {
        let noAVDLabel = UILabel()
        noAVDLabel.text = "No AV device enabled"
        noAVDLabel.textColor = .white
        noAVDLabel.frame = view.frame
        noAVDLabel.textAlignment = .center
        view.addSubview(noAVDLabel)
    }
    
    // MARK: - Alerts
    
    func showScannedAlert() {
        let detailView = PointsDetail(item: scannedItem)
        detailView.scanDelegate = scanSession
        
        let speciesName = repository.getDetailValue(item: scannedItem, property: "species_name")
        let scannedAlert = UIAlertController(title: scannedItem.label, message: speciesName, preferredStyle: .alert)
        
        scannedAlert.addAction(UIAlertAction(title: "Learn More", style: .default, handler: { (nil) in
            self.present(detailView, animated: true) {}
        }))
        
        scannedAlert.addAction(UIAlertAction(title: "Submit Photo", style: .default, handler: { (nil) in
            self.startSubmission()
        }))

        present(scannedAlert, animated: true) {}
    }
    
    func showThanksAlert() {
        let thanksAlert = UIAlertController(title: "Thanks!", message: "Would you like to add another photo to this submission?", preferredStyle: .alert)
        
        thanksAlert.addAction(UIAlertAction(title: "Yes", style: .default) { (nil) in
            self.dismiss(animated: true) {}
            self.continueSubmission()
        })
        
        thanksAlert.addAction(UIAlertAction(title: "No", style: .default) { (nil) in
            self.dismiss(animated: true) {}
            self.scanSession.enableScanning()
            self.sendSubmission()
        })
        
        present(thanksAlert, animated: true) {}
    }
    
    // MARK: - Submissions
    
    func startSubmission() {
        print("creating new submission for \(scannedItem.label!)")
        workingSubmission = Submission(date: Date())
        scannedItem.addToSubmissions(workingSubmission)
        openCamera()
    }
    
    func continueSubmission() {
        print("adding to existing submission for \(scannedItem.label!)")
        openCamera()
    }
    
    func sendSubmission() {
        repository.saveContext()
        print("sending submission for \(scannedItem.label!) with \(workingSubmission.userPhotos?.count ?? 0) photos")
        
        // begin UrlSession to send submission to API
        
    }
    
}

// MARK: - Image Picker Delegate

// Delegates and controllers
extension CaptureView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.scanDelegate = scanSession
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = .rear
        imagePicker.allowsEditing = false
        imagePicker.showsCameraControls = true
    }
    
    func openCamera() {
        let loadingScreen = LoadView()
        loadingScreen.show(in: view)
        present(imagePicker, animated: true) {
            loadingScreen.remove()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true) {}
        showThanksAlert()
        savePhoto(using: info)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true) {}
        scanSession.enableScanning()
    }
    
    func savePhoto(using info: [UIImagePickerController.InfoKey : Any]) {
        // handle the user photo in the background (snappy UI)
        DispatchQueue.global(qos: .userInitiated).async {
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            let hashString = image.pngData()!.md5()
            
            ImageManager.storeImage(image: image, with: hashString, to: .photos)
            print("photo saved to documents with filename \(hashString)")

            self.addPhotoToSubmission(from: hashString)
        }
    }
    
    func addPhotoToSubmission(from hash: String) {
        let url = ImageManager.getPath(for: hash, in: .photos)
        let userPhoto = UserPhoto(photoHash: hash, photoUrl: url)
        self.workingSubmission.addToUserPhotos(userPhoto)
        print("photo added to \(self.scannedItem.label!) submission with \(self.workingSubmission.userPhotos?.count ?? 0) photos")
    }
}
