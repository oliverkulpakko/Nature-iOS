//
//  Analytics.swift
//  Nature
//
//  Created by Oliver Kulpakko on 24/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import UIKit

class Analytics {
	
	/// Log an action to analytics
	///
	/// - Parameters:
	///   - action: Name of the action, required
	///   - data: Additional data for the action. Not required.
	class func log(action: String, error: String = "", data1: String = "", data2: String = "") {
		Analytics.updateCount(for: action)
		
		print("Analytics - Action: \(action), error: \(error.nilIfEmpty ?? "No Error"), data1: \(data1.nilIfEmpty ?? "No data1"), data2: \(data2.nilIfEmpty ?? "No data2")")
		
		let bundleID = Bundle.main.bundleIdentifier ?? ""
		let appVersion = ((Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "0000")
		
		let osVersion = ProcessInfo.processInfo.operatingSystemVersion
		let osVersionString = String(osVersion.majorVersion) + "." + String(osVersion.minorVersion) + "." + String(osVersion.patchVersion)
		
		let language = Locale.preferredLanguages.first ?? "UNKNOWN"
		
		let body = [
			"uuid": analyticsID,
			"appBundleId": bundleID,
			"appVersion": appVersion,
			"platform": UIDevice.current.model,
			"osName": "iOS",
			"osVersion": osVersionString,
			"deviceType": UIDevice.current.modelName,
			"language": language,
			"action": action,
			"error": error,
			"data1": data1,
			"data2": data2
		].httpBody
		
		if !UserDefaults.standard.bool(forKey: "DisableServerAnalytics") {
			if let url = URL(string: "https://eaststudios.net/api/Analytics/") {
				API.makeRequest(url: url, method: "POST", body: body, completion: nil)
			}
		}
	}
	
	class func count(for action: String) -> Int {
		var count = 0
		if var dictionary = UserDefaults.standard.dictionary(forKey: "AnalyticsCounts") {
			if let value = (dictionary[action] as? Int) {
				count = value
			}
		}
		return count
	}
	
	class func updateCount(for action: String) {
		if var dictionary = UserDefaults.standard.dictionary(forKey: "AnalyticsCounts") {
			if let value = dictionary[action] {
				dictionary[action] = value as! Int + 1
			} else {
				dictionary[action] = 1
			}
			UserDefaults.standard.set(dictionary, forKey: "AnalyticsCounts")
		} else {
			let dictionary = [action:1]
			UserDefaults.standard.set(dictionary, forKey: "AnalyticsCounts")
		}
	}
	
	private static var analyticsID: String {
		if let id = UserDefaults.standard.string(forKey: "AnalyticsID") {
			return id
		}
		
		let id = UUID().uuidString
		
		UserDefaults.standard.set(id, forKey: "AnalyticsID")
		
		return id
	}
}

private extension UIDevice {
	var modelName: String {
		var systemInfo = utsname()
		uname(&systemInfo)
		let machineMirror = Mirror(reflecting: systemInfo.machine)
		let identifier = machineMirror.children.reduce("") { identifier, element in
			guard let value = element.value as? Int8, value != 0 else { return identifier }
			return identifier + String(UnicodeScalar(UInt8(value)))
		}
		return identifier
	}
}
