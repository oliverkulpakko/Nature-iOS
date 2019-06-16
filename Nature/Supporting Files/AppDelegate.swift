//
//  AppDelegate.swift
//  Nature
//
//  Created by Oliver Kulpakko on 18/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import UIKit
import Analytics

let analytics = AnalyticsService(user: AnalyticsStore.analyticsID, environment: .production)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		checkUpdate()
		showInitialViewController()

		AnalyticsStore.appLaunchCount += 1
		analytics.logAction("LaunchApp")
		
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
			analytics.logAction("UpdateApp", data1: lastVersion, data2: currentVersion)
		}
		
		UserDefaults.standard.set(currentVersion, forKey: "AppLastVersion")
		
	}
}

