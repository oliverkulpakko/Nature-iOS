//
//  AppDelegate.swift
//  Nature
//
//  Created by Oliver Kulpakko on 18/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        showInitialViewController()
        
        return true
    }
    
    func showInitialViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let viewController = CategoriesViewController()
        
        window!.rootViewController = viewController
        window?.makeKeyAndVisible()
    }

}

