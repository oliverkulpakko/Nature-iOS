//
//  CLLocationManager.swift
//  Nature
//
//  Created by Oliver Kulpakko on 03/05/2019.
//  Copyright © 2019 Oliver Kulpakko. All rights reserved.
//

import CoreLocation

extension CLLocationManager {
	var isAuthorized: Bool {
		let status = CLLocationManager.authorizationStatus()

		return status == .authorizedAlways || status == .authorizedWhenInUse
	}
}
