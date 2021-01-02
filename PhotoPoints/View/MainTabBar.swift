//
//  MainTabBar.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 4/7/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import UIKit

class MainTabBar: UITabBarController {
    
    let repository = Repository.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBarChildren()
    }
    
    func setUpTabBarChildren() {

        // set up plant library
        let itemCollectionView = ItemCollectionView(collectionViewLayout: UICollectionViewFlowLayout())
        let itemNavigation = UINavigationController(rootViewController: itemCollectionView)
        itemNavigation.navigationBar.topItem?.title = "North Creek Forest"
        itemNavigation.tabBarItem = UITabBarItem(title: "Points", image: UIImage(systemName: "smallcircle.circle"), tag: 1)
        
        // set up map:
        let mapView = MapView()
        let mapNavigation = UINavigationController(rootViewController: mapView)
//        mapNavigation.navigationBar.isHidden = true
        mapNavigation.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), tag: 2)
        
        // set up scanner
        let scannerView = CaptureView()
        let scannerNavigation = UINavigationController(rootViewController: scannerView)
//        scannerNavigation.navigationBar.isHidden = true
        scannerNavigation.tabBarItem = UITabBarItem(title: "Capture", image: UIImage(systemName: "camera"), tag: 0)
        
        // add these to our main tab bar
        self.addChild(itemNavigation)
        self.addChild(mapNavigation)
        self.addChild(scannerNavigation)

    }
    
}

