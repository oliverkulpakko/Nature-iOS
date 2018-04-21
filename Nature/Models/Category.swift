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
	
	private let imageName: String
	private let hexColor: String
	
	let useLightText: Bool
	
	var items: [Item]
	
	// MARK: Computed Properties
	
	var image: UIImage? {
		return UIImage(named: imageName)
	}
	
	var color: UIColor {
		return UIColor(hex: hexColor)
	}
}
