//
//  HideableStatusBarNavigation.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 1/20/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

class HideableStatusBarNavigation: UINavigationController {
    
    var barHidden = false
    
    override var prefersStatusBarHidden: Bool {
        return barHidden
    }
    
}
