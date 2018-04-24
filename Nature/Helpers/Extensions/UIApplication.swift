//
//  UIApplication.swift
//  Nature
//
//  Created by Oliver Kulpakko on 24.4.2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import UIKit

extension UIApplication {

	var appVersion: String {
		return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
	}
	
	var appBuild: String {
		return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
	}
	
	var formattedVersion: String {
		return appVersion + " (" + appBuild + ")"
	}
}
