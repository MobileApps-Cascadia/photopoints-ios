//
//  PhotoPages.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 1/18/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

class PhotoPage: UIViewController {
    
    convenience init(image: UIImage) {
        self.init()
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = view.frame
        view.addSubview(imageView)
        view.backgroundColor = UIColor(named: "pp-background")
    }
    
}

class PhotoPages: UIPageViewController, UIPageViewControllerDataSource {
    
    var userPhotos: [UserPhoto]
    var index: Int
    
    init(userPhotos: [UserPhoto], index: Int) {
        self.userPhotos = userPhotos
        self.index = index
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        dataSource = self
        
        // photo hashes should not be optional
        let hash = userPhotos[index].photoHash!
        let image = ImageManager.getImage(from: hash, in: .photos)!
        let photoPage = [PhotoPage(image: image)]
        
        setViewControllers(photoPage, direction: .forward, animated: true, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if index == 0 {
            return nil
        }
        
        let hash = userPhotos[index - 1].photoHash!
        let image = ImageManager.getImage(from: hash, in: .photos)!
        index -= 1
        return PhotoPage(image: image)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if index == userPhotos.count - 1 {
            return nil
        }
        
        let hash = userPhotos[index + 1].photoHash!
        let image = ImageManager.getImage(from: hash, in: .photos)!
        index += 1
        return PhotoPage(image: image)
    }
    
}
