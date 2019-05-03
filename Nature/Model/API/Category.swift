//
//  Category.swift
//  Nature
//
//  Created by Oliver Kulpakko on 18/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import UIKit

struct Category: Codable {
	let id: String
	let name: String
	let notice: String?
	
	let countryCode: String
	
	let imageName: String
	let hexColor: String
	
	let useLightText: Bool

	let itemCount: Int
	
	// MARK: Computed Properties
	
	var image: UIImage? {
		return UIImage(named: "section." + imageName)
	}
	
	var color: UIColor {
		return UIColor(hex: hexColor)
	}
}
