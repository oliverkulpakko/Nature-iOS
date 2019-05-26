//
//  UIColor.swift
//  Nature
//
//  Created by Oliver Kulpakko on 18/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import UIKit

extension UIColor {
	convenience init(hex: String) {
			var string = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
			
			if string.hasPrefix("#") {
				string.remove(at: string.startIndex)
			}
			
			if (string.count) != 6 {
				self.init(red: 0, green: 0, blue: 0, alpha: 1)
				return
			}
			
			var rgbValue: UInt32 = 0
			Scanner(string: string).scanHexInt32(&rgbValue)
			
			self.init(
				red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
				green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
				blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
				alpha: CGFloat(1.0)
			)
	}

	func lighter(by percentage: CGFloat = 30.0) -> UIColor {
		return self.adjust(by: abs(percentage))
	}

	func darker(by percentage: CGFloat = 30.0) -> UIColor {
		return self.adjust(by: -1 * abs(percentage))
	}

	func adjust(by percentage: CGFloat = 30.0) -> UIColor {
		var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0

		if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
			return UIColor(red: min(red + percentage/100, 1.0),
						   green: min(green + percentage/100, 1.0),
						   blue: min(blue + percentage/100, 1.0),
						   alpha: alpha)
		} else {
			return self
		}
	}
}
