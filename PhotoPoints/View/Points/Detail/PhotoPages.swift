//
//  PhotoPages.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 1/18/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

class PhotoPage: UIViewController {
    
    let image: UIImage
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = view.frame
        return imageView
    }()
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
        view.addSubview(imageView)
        view.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class PhotoPages: UIPageViewController, UIPageViewControllerDataSource {
    
    var images = [UIImage]()
    var barsAreHidden = false
    
    init(userPhotos: [UserPhoto], index: Int) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        dataSource = self
        addGestureRecognizers()

        for userPhoto in userPhotos {
            // note - I don't think photo hashes should be optional
            let hash = userPhoto.photoHash!
            let image = ImageManager.getImage(from: hash, in: .photos)!
            images.append(image)
        }

        let photoPage = [PhotoPage(image: images[index])]
        
        setViewControllers(photoPage, direction: .forward, animated: true, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleHideBars))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func toggleHideBars() {
        UIView.animate(withDuration: 0.2) {
            if self.barsAreHidden {
                self.tabBarController?.tabBar.alpha = 1
                self.navigationController?.navigationBar.alpha = 1
                self.navigationController?.setNeedsStatusBarAppearanceUpdate()
            } else {
                self.tabBarController?.tabBar.alpha = 0
                self.navigationController?.navigationBar.alpha = 0
                self.navigationController?.setNeedsStatusBarAppearanceUpdate()
            }
        }
        barsAreHidden.toggle()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        // incrementing class scope index will not work, as both vcBefore and vcAfter called
        // getting index from the current image works, though
        let currentImage = (viewController as! PhotoPage).image
        let currentIndex = images.firstIndex(of: currentImage)!
        
        if currentIndex > 0 {
            return PhotoPage(image: images[currentIndex - 1])
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let currentImage = (viewController as! PhotoPage).image
        let currentIndex = images.firstIndex(of: currentImage)!
        
        if currentIndex < images.count - 1 {
            return PhotoPage(image: images[currentIndex + 1])
        }
        
        return nil
    }
    
}
