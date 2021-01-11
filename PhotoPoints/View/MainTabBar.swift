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
        
        // set up point collection view
//        let itemCollectionView = ItemCollectionView(collectionViewLayout: UICollectionViewFlowLayout())
//        let itemNavigation = UINavigationController(rootViewController: itemCollectionView)
        let pointsTable = PointsTable(style: .grouped)
        let pointsNavigation = UINavigationController(rootViewController: pointsTable)
        pointsNavigation.tabBarItem = UITabBarItem(title: "Points", image: UIImage(systemName: "smallcircle.circle"), tag: 0)
        
        // set up map:
        let mapView = MapView()
        let mapNavigation = UINavigationController(rootViewController: mapView)
        mapNavigation.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), tag: 1)
        
        // set up scanner
        let captureView = CaptureView()
        let captureNavigation = UINavigationController(rootViewController: captureView)
        captureNavigation.tabBarItem = UITabBarItem(title: "Capture", image: UIImage(systemName: "camera"), tag: 2)
        
        // add these to our main tab bar
        self.addChild(pointsNavigation)
        self.addChild(mapNavigation)
        self.addChild(captureNavigation)

    }
    
}

