//
//  AppDelegate.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 5/4/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        StartupManager.run()
        
        window = UIWindow()
        window?.rootViewController = MainTabBar()
        window?.makeKeyAndVisible()
        
        return true
    }

}

