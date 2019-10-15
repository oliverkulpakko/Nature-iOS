//
//  Theme.swift
//  Nature
//
//  Created by Oliver Kulpakko on 21/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import UIKit

struct Theme {
	var tintColor: UIColor
	
	var barStyle: UIBarStyle
	var keyboardAppearance: UIKeyboardAppearance
	
	var viewBackgroundColor: UIColor
	var textColor: UIColor
	
	var tableViewSeparatorColor: UIColor
	var cellBackgroundColor: UIColor

	static var current: Theme {
		if #available(iOS 13.0, *) {
			return Theme(tintColor: UIColor(red: 0.02, green: 0.71, blue: 0.13, alpha: 1.0),
						 barStyle: .default,
						 keyboardAppearance: .default,
						 viewBackgroundColor: .systemGroupedBackground,
						 textColor: .label,
						 tableViewSeparatorColor: UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0),
						 cellBackgroundColor: .systemBackground)
		}
		
		return Theme(tintColor: UIColor(red: 0.02, green: 0.71, blue: 0.13, alpha: 1.0),
					 barStyle: .default,
					 keyboardAppearance: .light,
					 viewBackgroundColor: .groupTableViewBackground,
					 textColor: .darkText,
					 tableViewSeparatorColor: UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0),
					 cellBackgroundColor: .white)
	}
}
