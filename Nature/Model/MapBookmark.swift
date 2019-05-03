//
//  MapBookmark.swift
//  Nature
//
//  Created by Oliver Kulpakko on 21/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import MapKit

class MapBookmark: NSObject, MKAnnotation, Codable, Comparable {
	var title: String?
	
	var subtitle: String? {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .medium
		let string = dateFormatter.string(from: creationDate)
		return string
	}
	
	var coordinate: CLLocationCoordinate2D
	var creationDate: Date
	var id: String
	
	init(title: String, coordinate: CLLocationCoordinate2D) {
		self.title = title
		
		self.coordinate = coordinate
		self.creationDate = Date()
		self.id = UUID().uuidString
	}
	
	// MARK: Comparable
	
	static func < (lhs: MapBookmark, rhs: MapBookmark) -> Bool {
		return lhs.creationDate < rhs.creationDate
	}
	
	// MARK: Equatable
	
	static func == (lhs: MapBookmark, rhs: MapBookmark) -> Bool {
		return lhs.id == rhs.id
	}
}
