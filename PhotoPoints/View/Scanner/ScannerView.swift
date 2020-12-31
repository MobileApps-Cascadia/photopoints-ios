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
class ScannerView: UIViewController {
    
    // MARK: - Properties
    
    let repository = Repository.instance
    
    // keeps track of whether or not an alert should be allowed to present when scanning
    var alertActive = false
    
    // video session: optional because we won't have it in our emulator
    var session: AVCaptureSession! = nil
    
    let scannerSquare: UIView = {
        let square = UIView()
        square.layer.borderWidth = 3
        square.layer.borderColor = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1)
        return square
    }()
    
    let loadingScreen = LoadView()
    
    // photo capture view
    let imagePicker = ImagePickerWithAlert()
    
    // this variable won't be referenced unless an item has been identified with the scanner
    var scannedItem: Item!
    
    var workingSubmission: Submission!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScanner()
        setupImagePicker()
    }
    
    // terminate the session if we navigate off this view
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session?.stopRunning()
        
        // commit submissions to core data once the user has left this screen
        repository.saveContext()
    }
    
    // bring the session up again if we switch back to this view
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        session?.startRunning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Scanner
    
    func setupScanner() {
         // if a default capture device exists, hook up input, config output, and display
        if let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) {
            session = AVCaptureSession()
            addAVInput(from: captureDevice)
            configureAVOutput(for: .qr)
            addVideoLayer()
            setupScannerSquare()
            session.startRunning()
        } else {
            addNoAVDLabel()
        }
    }
    
    // take input from our camera device and put it in our session
    func addAVInput(from device: AVCaptureDevice) {
        do {
            let input = try AVCaptureDeviceInput(device: device)
            session.addInput(input)
        } catch {
           print("ERROR")
        }
    }
    
    func configureAVOutput(for objectType: AVMetadataObject.ObjectType) {
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        // process output on main thread: best performance results
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [objectType]
    }
    
    func addVideoLayer() {
        let video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
    }
    
    // MARK: - View Setup
    
    func setupScannerSquare() {
        view.addSubview(scannerSquare)
        let width = view.frame.width - 64
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
        noAVDLabel.sizeToFit()
        noAVDLabel.frame = view.frame
        noAVDLabel.textAlignment = .center
        view.addSubview(noAVDLabel)
    }
    
    // MARK: - Alerts
    
    func showScannedAlert(for item: Item) {
        let detailView = ItemDetailView(item: item)
        detailView.alertDelegate = self
        
        let botanicalName = repository.getDetailValue(item: item, property: "botanical_name")
        let scannedAlert = UIAlertController(title: item.label, message: botanicalName, preferredStyle: .alert)
        
        scannedAlert.addAction(UIAlertAction(title: "Learn More", style: .default, handler: { (nil) in
            self.present(detailView, animated: true) {}
        }))
        
        scannedAlert.addAction(UIAlertAction(title: "Submit Photo", style: .default, handler: { (nil) in
            self.workingSubmission = self.getWorkingSubmission(for: item)
            self.openCamera()
        }))

        present(scannedAlert, animated: true) {}
    }
    
    func showThanksAlert() {
        let thanksAlert = UIAlertController(title: "Thanks!", message: "Would you like to add another photo to this submission?", preferredStyle: .alert)
        
        thanksAlert.addAction(UIAlertAction(title: "Yes", style: .default) { (nil) in
            self.dismiss(animated: true) {}
            self.openCamera()
        })
        
        thanksAlert.addAction(UIAlertAction(title: "No", style: .default) { (nil) in
            self.dismiss(animated: true) {}
        })
        
        present(thanksAlert, animated: true) {}
    }
    
    // MARK: - Submissions
    
    func getWorkingSubmission(for item: Item) -> Submission {
        
        if repository.didSubmitToday(for: item) {
            let submission = repository.getSubmissions(for: item)!.last!
            print("adding to existing submission for \(item.label ?? "") with \(submission.userPhotos?.count ?? 0) photos")
            return submission
        }
        
        print("creating new submission for \(item.label ?? "")")
        let submission = Submission(date: Date())
        item.addToSubmissions(submission)
        return submission
    }
    
}

// MARK: - Meta Data Output

extension ScannerView: AVCaptureMetadataOutputObjectsDelegate {

    // called by system when we get metadataoutputs
    // load the scanned item into the class variable
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if  metadataObjects.count != 0 && !alertActive {
            let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            guard let objectString = object?.stringValue else { return }
            guard let item = repository.getItemFrom(url: objectString) else { return }
            showScannedAlert(for: item)
            scannedItem = item
            alertActive = true
            print("alert active")
        }
    }
    
}

// MARK: - Image Picker Delegate

// Delegates and controllers
extension ScannerView: UIImagePickerControllerDelegate, UINavigationControllerDelegate, AlertDelegate {
    
    func turnOffAlert() {
        alertActive = false
        print("alert inactive")
    }
    
    func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.alertDelegate = self
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
    
    func submitPhoto(using info: [UIImagePickerController.InfoKey : Any], for item: Item) {
        // handle the user photo in the background (this really helps speed up the UI here!)
        DispatchQueue.global(qos: .userInitiated).async {
            
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let data = image.pngData() else {
                print("error getting png data for user photo")
                return
            }

            let hashString = Insecure.MD5.hash(data: data).map {
                String(format: "%02hhx", $0)
            }.joined()

            ImageManager.storeImage(image: image, with: hashString, to: .photos)
            print("photo stored with filename \(hashString)")

            let url = ImageManager.getPath(for: hashString, in: .photos)
            let userPhoto = UserPhoto(photoHash: hashString, photoUrl: url)
            self.workingSubmission.addToUserPhotos(userPhoto)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true) {}
        showThanksAlert()
        submitPhoto(using: info, for: scannedItem)
    }
    
}
