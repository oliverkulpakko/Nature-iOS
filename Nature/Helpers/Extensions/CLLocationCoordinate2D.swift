//
//  CLLocationCoordinate2D.swift
//  Nature
//
//  Created by Oliver Kulpakko on 21/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import CoreLocation

extension CLLocationCoordinate2D: Codable {
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.unkeyedContainer()
		
		try container.encode(latitude)
		try container.encode(longitude)
	}
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()

		let latitude = try container.decode(Double.self)
		let longitude = try container.decode(Double.self)
		
		self.init(latitude: latitude, longitude: longitude)
	}
}
