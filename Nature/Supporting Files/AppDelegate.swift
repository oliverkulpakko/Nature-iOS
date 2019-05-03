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
		checkUpdate()
		
		showInitialViewController()
		
        return true
    }
    
    func showInitialViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
		
        let viewController = CategoriesViewController()
        
        let navigationController = UINavigationController(rootViewController: viewController)
		
		window?.tintColor = Theme.current.tintColor
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
	
	func checkUpdate() {
		let lastVersion = UserDefaults.standard.string(forKey: "AppLastVersion")
		let currentVersion = UIApplication.shared.appBuild
		
		if let lastVersion = lastVersion, (lastVersion != currentVersion) {
			Analytics.log(action: "UpdateApp", error: "", data1: lastVersion, data2: currentVersion)
			
			UserDefaults.standard.set(true, forKey: "ForceRefreshData")
		}
		
		UserDefaults.standard.set(currentVersion, forKey: "AppLastVersion")
		
	}
}

