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
    
    // video session: optional because we won't have it in our emulator
    var session: AVCaptureSession! = nil
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScanner()
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
    
    func setUpScanner() {
         // if a default capture device exists, hook up input, config output, and display
        if let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) {
            session = AVCaptureSession()
            addAVInput(from: captureDevice)
            configureAVOutput(for: .qr)
            addVideoLayer()
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
                
                let plantURLs = MockDatabase.getURlStrings()
                let objectString = object.stringValue ?? ""
                
                if plantURLs.contains(objectString) {
                    let thisPlant = MockDatabase.getPlantFromURLString(urlString: objectString)
                    setUpAlerts(for: thisPlant)
                }
            }
        }
    }
    
    func setUpAlerts(for plantItem: PlantItem) {
        let surveyedAlert = UIAlertController(title: "Thank you!", message: "survey complete", preferredStyle: .alert)
        surveyedAlert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        let scannedAlert = UIAlertController(title: plantItem.commonName, message: plantItem.botanicalName, preferredStyle: .alert)
        scannedAlert.addAction(UIAlertAction(title: "Perform Survey", style: .default, handler: { (nil) in
            plantItem.surveyStatus = .surveyed
            mapVC.didUpdateSurveyStatus(commonName: plantItem.commonName)
            self.present(surveyedAlert, animated: true, completion: nil)
        }))
        scannedAlert.addAction(UIAlertAction(title: "Learn More", style: .default, handler:  { (nil) in
            self.present(PlantDetailView(plantItem: plantItem), animated: true, completion: nil)
        }))
        present(scannedAlert, animated: true, completion: nil)
    }
    
}
