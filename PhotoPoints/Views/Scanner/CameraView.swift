//
//  CameraView.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 6/1/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import UIKit
import AVFoundation

class CameraView: UIViewController {
    
    var session: AVCaptureSession! = nil
    
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
    
    func setUpScanner() {
         // if a default capture device exists, hook up input, config output, and display
        if let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) {
            session = AVCaptureSession()
            addAVInput(from: captureDevice)
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

