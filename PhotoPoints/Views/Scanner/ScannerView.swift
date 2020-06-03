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
    
    // video session: optional because we won't have it in our emulator
    var session: AVCaptureSession! = nil
    
    let scannerSquare: UIView = {
        let square = UIView()
        square.layer.borderWidth = 3
        square.layer.borderColor = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1)
        return square
    }()
    
    let cameraButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 3
        button.layer.borderColor = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1)
        button.layer.cornerRadius = button.frame.height / 2
        button.addTarget(self, action: #selector(didTapCameraButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideo()
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
    
    func setupVideo() {
         // if a default capture device exists, hook up input, config output, and display
        if let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) {
            session = AVCaptureSession()
            addAVInput(from: captureDevice)
            configureAVOutput(for: .qr)
            addVideoLayer()
            setupCameraButton()
            setupScannerSquare()
            setScannerMode()
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

    func flashScreen() {
        let flash = CALayer()
        flash.frame = view.bounds
        flash.backgroundColor = UIColor.white.cgColor
        view.layer.addSublayer(flash)
        flash.opacity = 0

        let anim = CABasicAnimation(keyPath: "opacity")
        anim.fromValue = 0
        anim.toValue = 1
        anim.duration = 0.1
        anim.autoreverses = true
        anim.isRemovedOnCompletion = true

        flash.add(anim, forKey: "flashAnimation")
    }
    
    // MARK: - Selectors
    
    @objc func didTapCameraButton() {
        AudioServicesPlaySystemSound(1108)
        flashScreen()
        setScannerMode()
    }
    
    // MARK: - Switch Modes
    
    func setCameraMode() {
        cameraButton.isEnabled = true
        cameraButton.isHidden = false
        scannerSquare.isHidden = true
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    
    func setScannerMode() {
        cameraButton.isEnabled = false
        cameraButton.isHidden = true
        scannerSquare.isHidden = false
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - View Setup
    
    func setupScannerSquare() {
        view.addSubview(scannerSquare)
        let width = view.frame.width - 64
        scannerSquare.anchor(width: width, height: width)
        scannerSquare.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        scannerSquare.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setupCameraButton() {
        view.addSubview(cameraButton)
        let width: CGFloat = 64
        cameraButton.anchor(bottom: view.bottomAnchor, paddingBottom: 32, width: width, height: width)
        cameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cameraButton.layer.cornerRadius = 32
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

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension ScannerView: AVCaptureMetadataOutputObjectsDelegate {
    // called by system when we get metadataoutputs
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if  metadataObjects.count != 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                
                let qrCodes = repository.getQrCodes()
                print(qrCodes)
                
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
//        let surveyedAlert = UIAlertController(title: "Thank you!", message: "survey complete", preferredStyle: .alert)
//        surveyedAlert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        let commonName = repository.getDetailValue(item: item, property: "common_name")
        let botanicalName = repository.getDetailValue(item: item, property: "botanical_name")
        
        let scannedAlert = UIAlertController(title: commonName, message: botanicalName, preferredStyle: .alert)
        scannedAlert.addAction(UIAlertAction(title: "Perform Survey", style: .default, handler: { (nil) in
            // TODO: update survey status
            self.setCameraMode()
        }))
        scannedAlert.addAction(UIAlertAction(title: "Learn More", style: .default, handler:  { (nil) in
            self.present(ItemDetailView(item: item), animated: true, completion: nil)
        }))
        present(scannedAlert, animated: true, completion: nil)
    }
    
}
