//
//  PhotoPages.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 1/18/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

class PhotoPages: UIPageViewController {
    
    let photos: [UserPhoto]!
    
    init(photos: [UserPhoto]) {
        self.photos = photos
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
