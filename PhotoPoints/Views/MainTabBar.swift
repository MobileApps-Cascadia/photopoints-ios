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
        
        // set up repo
        
        let repo = Repository.instance
        repo.test()
        repo.testSync()
        repo.testDB()
        
        
        // set up scanner
        let scannerView = ScannerView()
        scannerView.tabBarItem = UITabBarItem(title: "Scanner", image: UIImage(systemName: "camera"), tag: 0)
        
        // set up plant library
        let plantsCollectionView = PlantsCollectionView(collectionViewLayout: UICollectionViewFlowLayout())
        let plantsNavigation = UINavigationController(rootViewController: plantsCollectionView)
        plantsNavigation.navigationBar.topItem?.title = "Plant Library"
        plantsNavigation.tabBarItem = UITabBarItem(title: "Plants", image: UIImage(systemName: "leaf.arrow.circlepath"), tag: 1)
        
        // set up map:
        // this is a (fake) singleton so we can change the surveystatus in scannerView and have it be reflected in map markers
        // we should make it a real singleton, or determine a better alternative (observable objects?)
        mapVC.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), tag: 2)
        
        // add these to our main tab bar
        self.addChild(scannerView)
        self.addChild(plantsNavigation)
        self.addChild(mapVC)
        
        // set library as default tab bar selection
        self.selectedIndex = 1
    }
    
}

