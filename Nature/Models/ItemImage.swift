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
	
	// MARK: Computed Variables
	
	var description: String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .medium
		
		return title + "\n\n" +
			dateFormatter.string(from: timestamp) + "\n\n" +
			license + ", © " + user
	}
}
