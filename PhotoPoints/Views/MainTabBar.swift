//
//  MainTabBar.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 4/7/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import UIKit
import RealmSwift

class MainTabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBarChildren()
    }
    
    func setUpTabBarChildren() {

        // set up scanner
        let scannerView = ScannerView()
        scannerView.tabBarItem = UITabBarItem(title: "Scanner", image: UIImage(systemName: "camera"), tag: 0)
        
        // set up plant library
        let itemCollectionView = ItemCollectionView(collectionViewLayout: UICollectionViewFlowLayout())
        let itemNavigation = UINavigationController(rootViewController: itemCollectionView)
        itemNavigation.navigationBar.topItem?.title = "Plant Library"
        itemNavigation.tabBarItem = UITabBarItem(title: "Plants", image: UIImage(systemName: "leaf.arrow.circlepath"), tag: 1)
        
        // set up map:
        // this is a (fake) singleton so we can change the surveystatus in scannerView and have it be reflected in map markers
        // we should make it a real singleton, or determine a better alternative (observable objects?)
        mapVC.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), tag: 2)
        
        // add these to our main tab bar
        self.addChild(scannerView)
        self.addChild(itemNavigation)
        self.addChild(mapVC)
        
        // set library as default tab bar selection
        self.selectedIndex = 1
    }
    
}

