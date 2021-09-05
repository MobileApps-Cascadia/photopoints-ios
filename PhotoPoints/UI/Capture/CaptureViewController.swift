//
//  CaptureViewController.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 9/4/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit
import AVFoundation

// delegate for triggering alert presentation outside of this class
protocol AlertDelegate {
    func showScannedAlert()
    func showThanksAlert()
}

class CaptureViewController: UIViewController {
    
    // MARK: - Properties
    
    let repository = Repository.instance
    let submissionManager = SubmissionManager.instance
    
    // video session: optional because we won't have it in our emulator
    var scanSession: QrScanSession?
    
    // photo capture view
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var videoContainer: UIView!
    @IBOutlet weak var scannerSquare: ScannerSquare!
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // if camera is available, set up scanner and image picker that use them
        if let session = QrScanSession(in: videoContainer) {
            scanSession = session
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
    
    @IBAction func onTapped(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true)
        scanSession?.enableScanning()
    }
}

// MARK: - Alerts

extension CaptureViewController: AlertDelegate {
    
    // create and present alert after item is scanned
    // called in SubmissionManager.scannedItem didSet
    func showScannedAlert() {
        guard let item = submissionManager.scannedItem else {
            return
        }
        
        let title = "PhotoPoint Identified!"
        let scannedAlert = UIAlertController(title: title, message: item.label, preferredStyle: .alert)
        
        let learnAction = UIAlertAction(title: "Learn More", style: .default) { _ in
            let detailView = PointsDetailViewController(item: item)
            detailView.scanDelegate = self.scanSession
            self.present(detailView, animated: true)
        }
        
        let submitAction = UIAlertAction(title: "Submit Photo", style: .default) { _ in
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
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.dismiss(animated: true)
            self.openCamera()
        }
        
        let noAction = UIAlertAction(title: "No", style: .default) { _ in
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
        // alert creates a view behind it that we can add the recognizer to
        // this allows us to dismiss when tapping outside of the alert
        let alertBackgroundView = alert.view.superview?.subviews.first
        
        alertBackgroundView?.addGestureRecognizer(tapRecognizer)
    }

}

// MARK: - Image Picker Delegate

// Delegates and controllers
extension CaptureViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = .rear
        imagePicker.allowsEditing = false
        imagePicker.showsCameraControls = true
    }
    
    func openCamera() {
        showLoadingIndicator()
        
        present(imagePicker, animated: true) {
            self.removeLoadingIndicator()
        }
    }
    
    // called when user picks a photo they've taken
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
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
