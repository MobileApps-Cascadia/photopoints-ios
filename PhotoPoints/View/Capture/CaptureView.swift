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
class CaptureView: UIViewController {
    
    // MARK: - Properties
    
    let repository = Repository.instance
    
    // keeps track of whether or not an alert should be allowed to present when scanning
    var scanningEnabled = true
    
    // video session: optional because we won't have it in our emulator
    var captureSession: AVCaptureSession! = nil
    
    let scannerSquare: UIView = {
        let square = UIView()
        square.layer.borderWidth = 2
        square.layer.borderColor = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1)
        square.layer.cornerRadius = 10
        return square
    }()
    
    let loadingScreen = LoadView()
    
    // photo capture view
    let imagePicker = ImagePickerWithScanDelegate()
    
    // these variables won't be referenced until they are assigned values
    var scannedItem: Item!
    var workingSubmission: Submission!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        setupScanner()
        
    }
    
    // terminate the session if we navigate off this view
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession?.stopRunning()
    }
    
    // bring the session up again if we switch back to this view
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession?.startRunning()
    }
    
    // MARK: - Scanner
    
    func setupScanner() {
         // if a default capture device exists, hook up input, config output, and display
        if let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) {
            captureSession = AVCaptureSession()
            addAVInput(from: captureDevice)
            configureAVOutput(for: .qr)
            addVideoLayer()
            captureSession.startRunning()
            addScannerSquare()
            setupImagePicker()
        } else {
            addNoAVDLabel()
        }
    }
    
    // take input from our camera device and put it in our session
    func addAVInput(from device: AVCaptureDevice) {
        do {
            let input = try AVCaptureDeviceInput(device: device)
            captureSession.addInput(input)
        } catch {
           print("ERROR")
        }
    }
    
    func configureAVOutput(for objectType: AVMetadataObject.ObjectType) {
        let output = AVCaptureMetadataOutput()
        captureSession.addOutput(output)
        
        // process output on main thread: best performance results
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [objectType]
    }
    
    func addVideoLayer() {
        let video = AVCaptureVideoPreviewLayer(session: captureSession)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
    }
    
    // MARK: - View Setup
    
    func configureNavBar() {
        navigationController?.navigationBar.topItem?.title = "Center QR Code in Square"
    }
    
    func addScannerSquare() {
        view.addSubview(scannerSquare)
        let width = view.frame.width - globalPadding! * 2
        scannerSquare.anchor(centerX: view.centerXAnchor, centerY: view.centerYAnchor, width: width, height: width)
    }
    
    func showLoadScreen() {
        loadingScreen.frame = view.frame
        loadingScreen.setUpIndicator()
        view.addSubview(loadingScreen)
    }
    
    func addNoAVDLabel() {
        let noAVDLabel = UILabel()
        noAVDLabel.text = "No AV Device"
        noAVDLabel.textColor = .white
        noAVDLabel.frame = view.frame
        noAVDLabel.textAlignment = .center
        view.addSubview(noAVDLabel)
    }
    
    // MARK: - Alerts
    
    func showScannedAlert() {
        let detailView = PointsDetail(item: scannedItem)
        detailView.scanDelegate = self
        
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
            self.enableScanning()
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

// MARK: - Meta Data Output

extension CaptureView: AVCaptureMetadataOutputObjectsDelegate {

    // called by system when we get metadataoutputs
    // load the scanned item into the class variable
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if  metadataObjects.count != 0 && scanningEnabled {
            let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            guard let objectString = object?.stringValue else { return }
            scannedItem = repository.getItemFrom(url: objectString)
            showScannedAlert()
            disableScanning()
        }
    }
    
}

// MARK: - Image Picker Delegate

// Delegates and controllers
extension CaptureView: UIImagePickerControllerDelegate, UINavigationControllerDelegate, ScanDelegate {
    
    func enableScanning() {
        scanningEnabled = true
        print("scanning enabled")
    }
    
    func disableScanning() {
        scanningEnabled = false
        print("scanning disabled")
    }
    
    func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.scanDelegate = self
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = .rear
        imagePicker.allowsEditing = false
        imagePicker.showsCameraControls = true
    }
    
    func openCamera() {
        showLoadScreen()
        present(imagePicker, animated: true) {
            self.loadingScreen.removeFromSuperview()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true) {}
        showThanksAlert()
        savePhoto(using: info)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true) {}
        enableScanning()
    }
    
    func savePhoto(using info: [UIImagePickerController.InfoKey : Any]) {
        // handle the user photo in the background (this really helps speed up the UI here!)
        DispatchQueue.global(qos: .userInitiated).async {
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            let data = image.pngData()!

            let hashString = Insecure.MD5.hash(data: data).map {
                String(format: "%02hhx", $0)
            }.joined()

            ImageManager.storeImage(image: image, with: hashString, to: .photos)
            print("photo saved to documents with filename \(hashString)")

            let url = ImageManager.getPath(for: hashString, in: .photos)
            let userPhoto = UserPhoto(photoHash: hashString, photoUrl: url)
            self.workingSubmission.addToUserPhotos(userPhoto)
            print("photo added to \(self.scannedItem.label!) submission with \(self.workingSubmission.userPhotos?.count ?? 0) photos")
        }
    }
}
