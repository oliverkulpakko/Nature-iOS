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
	
	let imageURL: String
	
	// MARK: Computed Properties
	
	var attributedDescription: NSAttributedString {
		let html = "<meta charset=\"UTF-8\"><style>body{text-align: center; font-family: '-apple-system', 'HelveticaNeue'; color: black; font-size: \(UIFont.systemFontSize)px;}ul, ol{text-align: left;}</style>" + description
		if let htmlData = NSString(string: html).data(using: String.Encoding.unicode.rawValue) {
			let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
			
			if let attributedString = try? NSAttributedString(data: htmlData, options: options, documentAttributes: nil) {
				return attributedString
			}
		}
		return NSAttributedString(string: "")
	}
}
