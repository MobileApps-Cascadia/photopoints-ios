//
//  ScannerView.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 4/7/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import UIKit
import AVFoundation

// code modified from https://www.youtube.com/watch?v=4Zf9dHDJ2yU
class ScannerView: UIViewController {
    
    // MARK: - Properties
    
    let repository = Repository.instance
    
    var alertActive = false
    
    // video session: optional because we won't have it in our emulator
    var session: AVCaptureSession! = nil
    
    let scannerSquare: UIView = {
        let square = UIView()
        square.layer.borderWidth = 3
        square.layer.borderColor = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1)
        return square
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScanner()
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
    
    func addNoAVDLabel() {
        let noAVDLabel = UILabel()
        noAVDLabel.text = "No AV Device"
        noAVDLabel.textColor = .white
        noAVDLabel.sizeToFit()
        
        // this needs to happen before setting constraints :)
        view.addSubview(noAVDLabel)
        noAVDLabel.translatesAutoresizingMaskIntoConstraints = false
        noAVDLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        noAVDLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
}

// MARK: - Image Picker

extension ScannerView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        imagePicker.showsCameraControls = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let hashString = String(image.hashValue)
            ImageManager.storeImage(image: image, with: hashString)
            self.dismiss(animated: true, completion: nil)
        } else {
            print("error")
        }
    }
    
}

// MARK: - Meta Data Output

extension ScannerView: AVCaptureMetadataOutputObjectsDelegate {
    // called by system when we get metadataoutputs
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if  metadataObjects.count != 0 && !alertActive {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                let qrCodes = repository.getQrCodes()
                let objectString = object.stringValue ?? ""
                
                if qrCodes.contains(objectString) {
                    if let thisItem = repository.getItemFromQrCode(qrCode: objectString) {
                        setUpAlerts(for: thisItem)
                    }
                }
            }
        }
    }
    
    func setUpAlerts(for item: Item) {
        let commonName = repository.getDetailValue(item: item, property: "common_name")
        let botanicalName = repository.getDetailValue(item: item, property: "botanical_name")
        
        let scannedAlert = UIAlertController(title: commonName, message: botanicalName, preferredStyle: .alert)
        scannedAlert.addAction(UIAlertAction(title: "Perform Survey", style: .default, handler: { (nil) in
            self.openCamera()
        }))
        scannedAlert.addAction(UIAlertAction(title: "Learn More", style: .default, handler: { (nil) in
            self.present(ItemDetailView(item: item), animated: true, completion: nil)
        }))
        
        present(scannedAlert, animated: true, completion: nil)
    }
    
}

