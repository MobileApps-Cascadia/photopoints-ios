//
//  ImagePickerWithAlert.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 12/31/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import UIKit

protocol AlertDelegate {
    func turnOffAlert()
}

class ImagePickerWithAlert: UIImagePickerController {
    
    // initialized to nil so we don't have to write a custom init
    var alertDelegate: AlertDelegate! = nil
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        alertDelegate.turnOffAlert()
    }
    
}
