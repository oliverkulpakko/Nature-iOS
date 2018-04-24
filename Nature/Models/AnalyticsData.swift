//
//  AnalyticsData.swift
//  Nature
//
//  Created by Oliver Kulpakko on 24/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import Foundation

struct AnalyticsData: Codable {
	let items: [AnalyticsItem]
	let count: Int
}

struct AnalyticsItem: Codable {
	let date: Int
	let bundleID: String
	let appVersion: String
	let ipCountry: String
	let userAgent: String
	let platform: String
	let osName: String
	let osVersion: String
	let deviceType: String
	let language: String
	let action: String
	let error: String
	let data1: String
	let data2: String
}
