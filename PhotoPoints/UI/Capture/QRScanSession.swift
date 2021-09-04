//
//  QrScanSession.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 1/31/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit
import AVFoundation

protocol ScanDelegate {
    var scanningEnabled: Bool { get }
    func disableScanning()
    func enableScanning()
}

class QrScanSession: AVCaptureSession {
    
    let repository = Repository.instance
    let submissionManager = SubmissionManager.instance
    var scanningEnabled = true
    
    // falliable init - the default capture device will not be available if running on emulator or if camera permissions denied
    init?(in view: UIView) {
        if let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) {
            super.init()
            addInput(from: captureDevice)
            lookForQrCodes()
            addVideoLayer(to: view)
        } else {
            return nil
        }
    }
    
    func addInput(from device: AVCaptureDevice) {
        do {
            let input = try AVCaptureDeviceInput(device: device)
            addInput(input)
        } catch {
            print("Error adding device input")
        }
    }
    
    func lookForQrCodes() {
        let output = AVCaptureMetadataOutput()
        addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [.qr]
    }
    
    func addVideoLayer(to view: UIView) {
        let video = AVCaptureVideoPreviewLayer(session: self)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
    }

}

extension QrScanSession: AVCaptureMetadataOutputObjectsDelegate {
    
    // called by system when we get metadataoutputs
    // load the scanned item into submission manager
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if scanningEnabled,
           let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let objectString = object.stringValue {
            submissionManager.scannedItem = repository.getItemFrom(url: objectString)
            disableScanning()
        }
    }
    
}

extension QrScanSession: ScanDelegate {
    
    func enableScanning() {
        scanningEnabled = true
        print("scanning enabled")
    }
    
    func disableScanning() {
        scanningEnabled = false
        print("scanning disabled")
    }
    
}