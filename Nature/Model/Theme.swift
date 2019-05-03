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
		if UserDefaults.standard.bool(forKey: "UseDarkTheme") {
			return .dark
		}
		
		return .light
	}
	
	static var light: Theme {
		return Theme(tintColor: UIColor(red: 0.02, green: 0.71, blue: 0.13, alpha: 1.0),
					 barStyle: .default,
					 keyboardAppearance: .light,
					 viewBackgroundColor: .groupTableViewBackground,
					 textColor: .darkText,
					 tableViewSeparatorColor: UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0),
					 cellBackgroundColor: .white)
	}
	
	static var dark: Theme {
		return Theme(tintColor: UIColor(red: 0.02, green: 0.71, blue: 0.13, alpha: 1.0),
					 barStyle: .blackTranslucent,
					 keyboardAppearance: .dark,
					 viewBackgroundColor: UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.0),
					 textColor: .white,
					 tableViewSeparatorColor: UIColor(red: 0.38, green: 0.38, blue: 0.38, alpha: 1.0),
					 cellBackgroundColor: UIColor(red: 0.21, green: 0.21, blue: 0.21, alpha: 1.0))
	}
}
