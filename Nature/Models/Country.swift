//
//  Country.swift
//  Nature
//
//  Created by Oliver Kulpakko on 18/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import Foundation

struct Country: Codable {
	let code: String
	let count: Int

	var localizedCountry: String {
		return Locale.current.localizedString(forRegionCode: code) ?? code
	}
}
