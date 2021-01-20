//
//  AdjustableBarStyleNavigation.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 1/20/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

class AdjustableBarStyleNavigation: UINavigationController {
    
    var light = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if light {
            light.toggle()
            return .default
        } else {
            light.toggle()
            return .lightContent
        }
    }
    
    
}
