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
	let description: String
	let image: ItemImage?
	let detailURL: String
	
	var category: Category? // This won't be decoded, it is set in DataHelper when fetching categories
	
	// MARK: Computed Properties
	
	var attributedDescription: NSAttributedString {
		let html = "<meta charset=\"UTF-8\"><style>body{text-align: center; font-family: '-apple-system', 'HelveticaNeue'; color: white; font-size: \(UIFont.systemFontSize)px;}ul, ol{text-align: left;}</style>" + description
		if let htmlData = NSString(string: html).data(using: String.Encoding.unicode.rawValue) {
			let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
			
			if let attributedString = try? NSAttributedString(data: htmlData, options: options, documentAttributes: nil) {
				return attributedString
			}
		}
		return NSAttributedString(string: "")
	}
	
	var latinName: String? {
		return description.slice(from: "</b> (<i>", to: "</i>) ") // This is very hacky, but it works
	}
	
	var searchText: String {
		return title + ":" + subtitle + ":" + (latinName ?? "")
	}
}
