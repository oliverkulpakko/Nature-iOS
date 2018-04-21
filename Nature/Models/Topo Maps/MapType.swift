//
//  MapType.swift
//  Topo Maps
//
//  Created by Oliver Kulpakko on 28.3.2018.
//  Copyright © 2018 East Studios. All rights reserved.
//

import Foundation

struct MapType: Codable, Comparable {
	let identifier: String
	let name, countryCode: String
	let highQuality: Bool
	let copyright: String
	let minZoom, maxZoom: Int
	let showcaseLatitude, showcaseLongitude: Double
	let inAppPurchaseID: String?
	let downloadingEnabled, opaque: Bool
	let tileExampleURL: String?
	let customMapURLTemplate: String?
	let extraMapTypes: [ExtraMapType]
	
	var localizedCountry: String {
		let locale = Locale.current as NSLocale
		return locale.displayName(forKey: .countryCode, value: countryCode) ?? countryCode
	}
	
	// MARK: Comparable
	
	static func < (lhs: MapType, rhs: MapType) -> Bool {
		return lhs.localizedCountry < rhs.localizedCountry
	}
	
	static func == (lhs: MapType, rhs: MapType) -> Bool {
		return lhs.identifier == rhs.identifier
	}
	
	// MARK: Codable
	
	enum CodingKeys: String, CodingKey {
		case identifier = "id"
		case name, highQuality, copyright, minZoom, maxZoom, showcaseLatitude, showcaseLongitude
		case countryCode = "country"
		case inAppPurchaseID = "inAppPurchaseId"
		case downloadingEnabled, opaque, extraMapTypes, tileExampleURL
		case customMapURLTemplate = "customMapUrl"
	}
}

struct ExtraMapType: Codable {
	let identifier, name, copyright: String
	
	enum CodingKeys: String, CodingKey {
		case identifier = "id"
		case name, copyright
	}
}
