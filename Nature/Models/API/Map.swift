//
//  Map.swift
//  TopoMaps6
//
//  Created by Oliver Kulpakko on 02/10/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import Foundation

struct Map: Codable {
	let id: String
	let country: String
	let type: String
	let urls: [URL]
	let copyright: Copyright
	let availability: Availability

	struct URL: Codable {
		let id: String
		let template: String
		let minZoom: Int
		let maxZoom: Int
	}

	struct Copyright: Codable {
		let owner: String
		let text: String
		let url: String
	}

	struct Availability: Codable {
		let isPurchased: Bool
		let inAppPurchaseID: String?
	}
}

extension Map: Equatable {
	static func == (lhs: Map, rhs: Map) -> Bool {
		return lhs.id == rhs.id
	}
}

extension Array where Element == Map {
	var sortedByCountry: [Map] {
		return sorted(by: { $0.country < $1.country })
	}
}

extension Array where Element == Map.URL {
	func urlForZoom(_ zoom: Int) -> Map.URL? {
		return first { $0.minZoom <= zoom && $0.maxZoom >= zoom }
	}

	var lowestZoomLevel: Int? {
		return sorted(by: { $0.minZoom < $1.minZoom }).first?.minZoom
	}

	var highestZoomLevel: Int? {
		return sorted(by: { $0.maxZoom > $1.maxZoom }).first?.maxZoom
	}
}
