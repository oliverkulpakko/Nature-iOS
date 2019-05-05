//
//  AnalyticsStore.swift
//  Nature
//
//  Created by Oliver Kulpakko on 04/05/2019.
//  Copyright © 2019 Oliver Kulpakko. All rights reserved.
//

import Foundation

class AnalyticsStore {
	private init() {}
	
	public static var analyticsID: String {
		if !analyticsIsEnabled {
			return "00000000-0000-0000-0000-000000000000"
		}

		if let id = UserDefaults.standard.string(forKey: "AnalyticsID") {
			return id
		}

		let id = UUID().uuidString
		UserDefaults.standard.set(id, forKey: "AnalyticsID")

		return id
	}

	public static var analyticsIsEnabled: Bool {
		return !UserDefaults.standard.bool(forKey: "DisableServerAnalytics")
	}

	public static var appLaunchCount: Int {
		get {
		return UserDefaults.standard.integer(forKey: "AppLaunchCount")
		}
		set {
			UserDefaults.standard.set(newValue, forKey: "AppLaunchCount")
		}
	}
}
