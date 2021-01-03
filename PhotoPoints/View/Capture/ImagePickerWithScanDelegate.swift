//
//  ImagePickerWithAlert.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 12/31/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import UIKit

protocol ScanDelegate {
    var scanningEnabled: Bool { get }
    func disableScanning()
    func enableScanning()
}

class ImagePickerWithScanDelegate: UIImagePickerController {
    
    // initialized to nil so we don't have to write a custom init
    var scanDelegate: ScanDelegate! = nil
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scanDelegate.disableScanning()
    }
    
}
