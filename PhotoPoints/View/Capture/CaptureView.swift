//
//  ScannerView.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 4/7/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import UIKit
import AVFoundation

// delegate for triggering alert presentation outside of this class
protocol AlertDelegate {
    func showScannedAlert()
    func showThanksAlert()
}

class CaptureView: UIViewController {
    
    // MARK: - Properties
    
    let repository = Repository.instance
    let submissionManager = SubmissionManager.instance
    
    // video session: optional because we won't have it in our emulator
    var scanSession: QrScanSession?
    
    // photo capture view
    let imagePicker = UIImagePickerController()

    let scannerSquare: UIView = {
        let square = UIView()
        square.layer.borderWidth = 2
        square.layer.borderColor = UIColor.white.cgColor
        square.layer.cornerRadius = 10
        return square
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // if camera is available, set up scanner and image picker that use them
        if let session = QrScanSession(in: view) {
            scanSession = session
            addScannerSquare()
            submissionManager.alertDelegate = self
            setupImagePicker()
            navigationController?.navigationBar.topItem?.title = "Center QR Code in Square"
        } else {
            
            // notify user camera is not available
            navigationController?.navigationBar.topItem?.title = "No AV Device Available"
        }
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
    
    // MARK: - View Setup
    
    func addScannerSquare() {
        view.addSubview(scannerSquare)
        let width = view.frame.width - .globalPadding * 2
        scannerSquare.anchor(
            centerX: view.centerXAnchor,
            centerY: view.centerYAnchor,
            width: width,
            height: width
        )
    }

}

// MARK: - Alerts

extension CaptureView: AlertDelegate {
    
    // create and present alert after item is scanned
    // called in SubmissionManager.scannedItem didSet
    func showScannedAlert() {
        let title = "PhotoPoint Identified!"
        let item = submissionManager.scannedItem!
        let scannedAlert = UIAlertController(title: title, message: item.label, preferredStyle: .alert)
        
        let learnAction = UIAlertAction(title: "Learn More", style: .default) { (nil) in
            let detailView = PointsDetail(item: item)
            detailView.scanDelegate = self.scanSession
            self.present(detailView, animated: true)
        }
        
        let submitAction = UIAlertAction(title: "Submit Photo", style: .default) { (nil) in
            self.submissionManager.startSubmission()
            self.openCamera()
        }
        
        scannedAlert.addAction(learnAction)
        scannedAlert.addAction(submitAction)

        self.present(scannedAlert, animated: true) {
            self.addTapRecognizer(to: scannedAlert)
        }
    }
    
    // create and present alert after photo taken
    func showThanksAlert() {
        let title = "Thanks!"
        let message = "Would you like to add another photo of this item?"
        let thanksAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (nil) in
            self.dismiss(animated: true)
            self.openCamera()
        }
        
        let noAction = UIAlertAction(title: "No", style: .default) { (nil) in
            self.dismiss(animated: true)
            self.scanSession?.enableScanning()
            self.submissionManager.sendSubmission()
        }
        
        thanksAlert.addAction(yesAction)
        thanksAlert.addAction(noAction)
        
        present(thanksAlert, animated: true) {
            self.addTapRecognizer(to: thanksAlert)
        }
    }
    
    func addTapRecognizer(to alert: UIAlertController) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlert))
        
        // alert creates a view behind it that we can add the recognizer to
        // this allows us to dismiss when tapping outside of the alert
        alert.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissAlert() {
        self.dismiss(animated: true)
        scanSession?.enableScanning()
    }
    
}

// MARK: - Image Picker Delegate

// Delegates and controllers
extension CaptureView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func setupImagePicker() {
        imagePicker.delegate = self
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
    
    // called when user picks a photo they've taken
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true) {}
        showThanksAlert()
        DispatchQueue.global(qos: .userInitiated).async {
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            self.submissionManager.savePhoto(image: image)
        }
    }
    
    // called when user cancels camera routine
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
        scanSession?.enableScanning()
    }
    
}
