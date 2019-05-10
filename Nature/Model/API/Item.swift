//
//  Item.swift
//  Nature
//
//  Created by Oliver Kulpakko on 18/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import UIKit

struct Item: Codable {
	let id: String
	let title: String
	let subtitle: String
	let scientificName: String?

	private let description: String
	
	let images: [Image]
	let detailURL: String
	
	// MARK: Computed Properties
	
	var attributedDescription: NSAttributedString {
		let html = "<meta charset=\"UTF-8\"><style>body{text-align: center; font-family: '-apple-system', 'HelveticaNeue'; font-size: \(UIFont.systemFontSize)px;}ul, ol{text-align: left;}</style>" + description

		return html.htmlToAttributedString ?? NSAttributedString(string: description)
	}
	
	var searchText: String {
		return title + ":" + subtitle + ":" + (scientificName ?? "")
	}

	struct Image: Codable {
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
}
