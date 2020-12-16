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
    
    let loadingScreen = LoadView(frame: UIScreen.main.bounds)
    
    // photo capture view
    lazy var imagePicker: ImagePickerWithAlertDelegate = {
        let ip = ImagePickerWithAlertDelegate()
        ip.delegate = self
        ip.alertDelegate = self
        ip.sourceType = .camera
        ip.cameraDevice = .rear
        ip.allowsEditing = false
        ip.showsCameraControls = true
        return ip
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
        view.addSubview(loadingScreen)
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
                }
            }
        }
    }
    
    func setUpAlerts(for item: Item) {
        let commonName = repository.getDetailValue(item: item, property: "common_name")
        let botanicalName = repository.getDetailValue(item: item, property: "botanical_name")
        let detailView = ItemDetailView(item: item)
        detailView.alertDelegate = self
        
        let scannedAlert = UIAlertController(title: commonName, message: botanicalName, preferredStyle: .alert)
        scannedAlert.addAction(UIAlertAction(title: "Perform Survey", style: .default, handler: { _ in
            
            self.showLoadScreen()
            
            DispatchQueue.main.async {
                
                self.openCamera()
            }
            
            
        }))
        scannedAlert.addAction(UIAlertAction(title: "Learn More", style: .default, handler: { _ in
            
            self.showLoadScreen()
            
            DispatchQueue.main.async {
                self.present(detailView, animated: true) { [weak self] in
                    self?.loadingScreen.removeFromSuperview()
                }
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
    
    func openCamera() {
        self.present(imagePicker, animated: true) { [weak self] in
            self?.loadingScreen.removeFromSuperview()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let data = image.pngData() {
            let hashString = Insecure.MD5.hash(data: data).map {
                String(format: "%02hhx", $0)
            }.joined()
            ImageManager.storeImage(image: image, with: hashString, to: .photos)
            print("photo stored with filename \(hashString)")
            self.dismiss(animated: true, completion: nil)
        } else {
            print("error storing user submission")
        }
    }
    
}
