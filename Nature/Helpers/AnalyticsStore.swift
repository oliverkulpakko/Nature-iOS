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

	public static var appLaunchCount: Int {
		get {
		return UserDefaults.standard.integer(forKey: "AppLaunchCount")
		}
		set {
			UserDefaults.standard.set(newValue, forKey: "AppLaunchCount")
		}
	}
}
