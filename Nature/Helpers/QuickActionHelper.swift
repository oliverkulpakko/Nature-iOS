//
//  QuickActionHelper.swift
//  Nature
//
//  Created by Oliver Kulpakko on 28/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import UIKit

class QuickActionHelper {
	static let maxCount = 3
	
	class func didOpenCategory(_ category: Category) {
		var categories = getCategories()
		
		categories.append(QuickActionCategory(id: category.id, name: category.name, imageName: category.imageName, addDate: Date()))
		
		categories = categories.uniqueElements // Remove duplicates
		
		if categories.count > maxCount {
			if let oldestCategory = categories.sorted().first {
				categories.remove(at: 0)
				print(oldestCategory)
			}
		}
		
		Storage.store(categories, to: .caches, as: "QuickActions")
		
		setQuickActions(categories)
	}
	
	class func setQuickActions(_ categories: [QuickActionCategory]) {
		var items = [UIApplicationShortcutItem]()
		
		for category in categories {
			let icon = UIApplicationShortcutIcon(templateImageName: "section." + category.imageName)
			
			items.append(UIApplicationShortcutItem(type: category.id,
												   localizedTitle: category.name,
												   localizedSubtitle: nil,
												   icon: icon,
												   userInfo: nil))
		}
		
		UIApplication.shared.shortcutItems = items
	}
	
	class func getCategories() -> [QuickActionCategory] {
		return Storage.retrieve("QuickActions", from: .caches, as: [QuickActionCategory].self) ?? []
	}
	
	struct QuickActionCategory: Codable, Comparable, Equatable {
		let id: String
		let name: String
		let imageName: String
		let addDate: Date
		
		static func == (lhs: QuickActionHelper.QuickActionCategory, rhs: QuickActionHelper.QuickActionCategory) -> Bool {
			return lhs.id == rhs.id
		}
		
		static func < (lhs: QuickActionHelper.QuickActionCategory, rhs: QuickActionHelper.QuickActionCategory) -> Bool {
			return lhs.addDate < rhs.addDate
		}
	}
}
