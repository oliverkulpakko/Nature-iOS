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
	
	func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
		let navigationController = window?.rootViewController as? UINavigationController
		let categoriesViewController = navigationController?.viewControllers.first as? CategoriesViewController
		
		let id = shortcutItem.type
		
		DataHelper.fetchCategory(id: id, forceRefresh: false, completion: { category, error in
			guard let category = category else {
				categoriesViewController?.showError(error)
				return
			}
			
			let itemsViewController = ItemsViewController()
			itemsViewController.category = category
			
			DispatchQueue.main.async {
				categoriesViewController?.navigationController?.popToRootViewController(animated: false) // Don't push to new ItemsViewController in "top of" another ItemsViewController
				
				categoriesViewController?.navigationController?.pushViewController(itemsViewController, animated: true)
			}
		})
	}
	
}

