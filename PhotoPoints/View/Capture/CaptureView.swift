//
//  ScannerView.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 4/7/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import UIKit
import AVFoundation

protocol AlertDelegate {
    func showScannedAlert()
    func showThanksAlert()
}

// code modified from https://www.youtube.com/watch?v=4Zf9dHDJ2yU
class CaptureView: UIViewController {
    
    // MARK: - Properties
    
    let repository = Repository.instance

    let submissionManager = SubmissionManager.instance
    
    // video session: optional because we won't have it in our emulator
    var scanSession: QrScanSession!
    
    // photo capture view
    let imagePicker = UIImagePickerController()

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
    
    // MARK: - Setup
    
    func setup() {
        if let session = QrScanSession(in: view) {
            scanSession = session
            addScannerSquare()
            submissionManager.alertDelegate = self
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
        let width = view.frame.width - .globalPadding * 2
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

}

// MARK: - Alerts

extension CaptureView: AlertDelegate {
    
    func showScannedAlert() {
        let title = "PhotoPoint Identified!"
        let item = submissionManager.scannedItem!
        let scannedAlert = UIAlertController(title: title, message: item.label, preferredStyle: .alert)
        
        let learnAction = UIAlertAction(title: "Learn More", style: .default) { (nil) in
            let detailView = PointsDetail(item: item)
            detailView.scanDelegate = self.scanSession
            self.present(detailView, animated: true) {}
        }
        
        let submitAction = UIAlertAction(title: "Submit Photo", style: .default) { (nil) in
            self.submissionManager.startSubmission()
            self.openCamera()
        }
        
        scannedAlert.addAction(learnAction)
        scannedAlert.addAction(submitAction)

        present(scannedAlert, animated: true) {}
    }
    
    func showThanksAlert() {
        let title = "Thanks!"
        let message = "Would you like to add another photo of this item?"
        let thanksAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (nil) in
            self.dismiss(animated: true) {}
            self.openCamera()
        }
        
        let noAction = UIAlertAction(title: "No", style: .default) { (nil) in
            self.dismiss(animated: true) {}
            self.scanSession.enableScanning()
            self.submissionManager.sendSubmission()
        }
        
        thanksAlert.addAction(yesAction)
        thanksAlert.addAction(noAction)
        
        present(thanksAlert, animated: true) {}
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true) {}
        showThanksAlert()
        submissionManager.savePhoto(image: getImage(from: info))
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true) {}
        scanSession.enableScanning()
    }
    
    func getImage(from info: [UIImagePickerController.InfoKey : Any]) -> UIImage {
        return info[UIImagePickerController.InfoKey.originalImage] as! UIImage
    }
    
}
