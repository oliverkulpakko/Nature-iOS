//
//  Country.swift
//  Nature
//
//  Created by Oliver Kulpakko on 18/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import Foundation

struct Country: Codable {
	let id: String
	let categoryCount: Int

	var localized: String {
		return Locale.current.localizedString(forRegionCode: id) ?? id
	}
}
