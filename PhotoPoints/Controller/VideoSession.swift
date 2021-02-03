//
//  VideoSession.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 1/31/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit
import AVFoundation

protocol ScannedItemDelegate {
    var scannedItem: Item! { set get }
}

class QrScanningSession: AVCaptureSession {
    
    let repository = Repository.instance
    
    // keeps track of whether or not an alert should be allowed to present when scanning
    var scanningEnabled = false
    
    var itemDelegate: ScannedItemDelegate!
    
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
            self.addInput(input)
        } catch {
            print("Error adding device input")
        }
    }
    
    func lookForQrCodes() {
        let output = AVCaptureMetadataOutput()
        self.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [.qr]
    }
    
    func addVideoLayer(to view: UIView) {
        let video = AVCaptureVideoPreviewLayer(session: self)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
    }

}

extension QrScanningSession: AVCaptureMetadataOutputObjectsDelegate {
    
    // called by system when we get metadataoutputs
    // load the scanned item into the class variable
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if  metadataObjects.count != 0 && scanningEnabled {
            let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            guard let objectString = object?.stringValue else { return }
            itemDelegate.scannedItem = repository.getItemFrom(url: objectString)
            disableScanning()
        }
    }
    
}

extension QrScanningSession: ScanDelegate {
    
    func enableScanning() {
        scanningEnabled = true
        print("scanning enabled")
    }
    
    func disableScanning() {
        scanningEnabled = false
        print("scanning disabled")
    }
    
}
