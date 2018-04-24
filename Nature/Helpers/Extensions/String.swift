//
//  String.swift
//  Nature
//
//  Created by Oliver Kulpakko on 18/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import Foundation

extension String {
    /// Returns a localized version of self
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
	
	var nilIfEmpty: String? {
		if isEmpty {
			return nil
		}
		
		return self
	}
	
	func slice(from: String, to: String) -> String? {
		return (range(of: from)?.upperBound).flatMap { substringFrom in
			(range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
				String(self[substringFrom..<substringTo])
			}
		}
	}
	
	func replacingTemplates(_ templates: [String: String]) -> String {
		var string = self
		for template in templates {
			string = string.replacingOccurrences(of: "{" + template.key + "}", with: template.value)
		}
		return string
	}
	
	mutating func replaceTemplates(_ templates: [String: String]) {
		self = replacingTemplates(templates)
	}

	var htmlToAttributedString: NSAttributedString? {
		guard let data = data(using: .utf8) else { return nil }
		do {
			return try NSAttributedString(data: data,
										  options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
		} catch {
			print(error)
			return nil
		}
	}
}
