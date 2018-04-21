//
//  ItemImage.swift
//  Nature
//
//  Created by Oliver Kulpakko on 19/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import Foundation

struct ItemImage: Codable {
	let id: Int
	let url: String
	let user: String
	let title: String
	let source: String
	let license: String
	let timestamp: Date
}
