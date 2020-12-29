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
    let imagePicker = ImagePickerWithAlertDelegate()
    
    var scannedItem: Item?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScanner()
        addDelegates()
    }
    
    // terminate the session if we navigate off this view
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session?.stopRunning()
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
        scannerSquare.anchor(width: width, height: width)
        scannerSquare.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        scannerSquare.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
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
    
}

// MARK: - Meta Data Output

extension ScannerView: AVCaptureMetadataOutputObjectsDelegate {

    // called by system when we get metadataoutputs
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if  metadataObjects.count != 0 && !alertActive {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                let objectString = object.stringValue ?? ""
                if let thisItem = repository.getItemFrom(url: objectString) {
                    alertActive = true
                    print("alert active")
                    setUpAlerts(for: thisItem)
                    scannedItem = thisItem
                }
            }
        }
    }
    
    func setUpAlerts(for item: Item) {
        let detailView = ItemDetailView(item: item)
        detailView.alertDelegate = self
        let botanicalName = repository.getDetailValue(item: item, property: "botanical_name")
        let scannedAlert = UIAlertController(title: item.label, message: botanicalName, preferredStyle: .alert)
        
        scannedAlert.addAction(UIAlertAction(title: "Submit Photo", style: .default, handler: { (nil) in
            self.showLoadScreen()
            self.openCamera()
        }))
        
        scannedAlert.addAction(UIAlertAction(title: "Learn More", style: .default, handler: { (nil) in
            self.showLoadScreen()
            self.present(detailView, animated: true) { [self] in
                self.loadingScreen.removeFromSuperview()
            }
        }))
        
        present(scannedAlert, animated: true, completion: nil)
    }
    
}

// MARK: - Image Picker

protocol AlertDelegate {
    func turnOffAlert()
}

class ImagePickerWithAlertDelegate: UIImagePickerController {
    
    // initialized to nil so we don't have to write a custom init
    var alertDelegate: AlertDelegate! = nil
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        alertDelegate.turnOffAlert()
    }
    
}

extension ScannerView: UIImagePickerControllerDelegate, UINavigationControllerDelegate, AlertDelegate {
    
    func turnOffAlert() {
        self.alertActive = false
        print("alert inactive")
    }
    
    func addDelegates() {
        imagePicker.delegate = self
        imagePicker.alertDelegate = self
    }
    
    func openCamera() {
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = .rear
        imagePicker.allowsEditing = false
        imagePicker.showsCameraControls = true
        self.present(imagePicker, animated: true) { [self] in
            self.loadingScreen.removeFromSuperview()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.dismiss(animated: true, completion: nil)
        
        // handle the user photo in the background (this really helps speed up the UI here!)
        DispatchQueue.global(qos: .userInitiated).async { [self] in

            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let data = image.pngData() else {
                print("error getting png data for user photo")
                return
            }

            let hashString = Insecure.MD5.hash(data: data).map {
                String(format: "%02hhx", $0)
            }.joined()

            ImageManager.storeImage(image: image, with: hashString, to: .photos)
            print("photo stored with filename \(hashString)")

            if let url = ImageManager.getPath(for: hashString, in: .photos) {

                let userPhoto = UserPhoto(photoHash: hashString, photoUrl: url)
                let submission = Submission(userPhoto: userPhoto, date: Date())
                self.scannedItem?.addToSubmissions(submission)
                
                do {
                    try self.repository.context.save()
                    print("context saved")
                } catch {
                    print("error saving context")
                }
                
            }
        }
    }
    
}
