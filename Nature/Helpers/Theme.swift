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
	var tableViewBackgroundColor: UIColor
	var keyboardAppearance: UIKeyboardAppearance
	
	var tableViewSeparatorColor: UIColor
	var cellBackgroundColor: UIColor
	var cellTextColor: UIColor
	
	static var current: Theme {
		if UserDefaults.standard.bool(forKey: "UseDarkTheme") {
			return .dark
		}
		
		return .light
	}
	
	static var light: Theme {
		return Theme(tintColor: UIColor(red: 0.30, green: 0.85, blue: 0.39, alpha: 1.0),
					 barStyle: .default,
					 tableViewBackgroundColor: .groupTableViewBackground,
					 keyboardAppearance: .light,
					 tableViewSeparatorColor: UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0),
					 cellBackgroundColor: .white,
					 cellTextColor: .darkText)
	}
	
	static var dark: Theme {
		return Theme(tintColor: UIColor(red: 0.30, green: 0.85, blue: 0.39, alpha: 1.0),
					 barStyle: .blackTranslucent,
					 tableViewBackgroundColor: UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.0),
					 keyboardAppearance: .dark,
					 tableViewSeparatorColor: UIColor(red: 0.38, green: 0.38, blue: 0.38, alpha: 1.0),
					 cellBackgroundColor: UIColor(red: 0.21, green: 0.21, blue: 0.21, alpha: 1.0),
					 cellTextColor: .white)
	}
}
