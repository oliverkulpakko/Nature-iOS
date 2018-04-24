//
//  Dictionary.swift
//  Nature
//
//  Created by Oliver Kulpakko on 24/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import Foundation

extension Sequence where Iterator.Element == (key: String, value: String) {
	var httpBody: String {
		var body = ""
		
		for (key, value) in self {
			body.append("&" + key + "=" + value)
		}
		
		return body
	}
}
