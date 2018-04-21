//
//  MapBookmark.swift
//  Nature
//
//  Created by Oliver Kulpakko on 21/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import MapKit

class MapBookmark: NSObject, MKAnnotation {
	var title: String?
	var subtitle: String?
	var coordinate: CLLocationCoordinate2D
	var creationDate: Date
	
	init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
		self.title = title
		self.subtitle = subtitle
		
		self.coordinate = coordinate
		self.creationDate = Date()
	}
}
