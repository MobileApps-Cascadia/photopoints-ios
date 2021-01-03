//
//  MainTabBar.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 4/7/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import UIKit

class MainTabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBarChildren()
    }
    
    func setUpTabBarChildren() {

        // set up scanner
        let scannerView = ScannerView()
        let scannerNavigation = UINavigationController(rootViewController: scannerView)
        scannerNavigation.navigationBar.topItem?.title = "Scanner"
        scannerNavigation.tabBarItem = UITabBarItem(title: "Scanner", image: UIImage(systemName: "camera"), tag: 0)
        
        // set up plant library
        let itemCollectionView = ItemCollectionView(collectionViewLayout: UICollectionViewFlowLayout())
        let itemNavigation = UINavigationController(rootViewController: itemCollectionView)
        itemNavigation.navigationBar.topItem?.title = "Plant Library"
        itemNavigation.tabBarItem = UITabBarItem(title: "Plants", image: UIImage(systemName: "leaf"), tag: 1)
        
        // set up map:
        let mapView = MapView()
        let mapNavigation = UINavigationController(rootViewController: mapView)
        mapNavigation.navigationBar.topItem?.title = "Map"
        mapNavigation.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), tag: 2)
        
        // add these to our main tab bar
        self.addChild(scannerNavigation)
        self.addChild(itemNavigation)
        self.addChild(mapNavigation)
        
        // set library as default tab bar selection
        self.selectedIndex = 1
    }
    
}

