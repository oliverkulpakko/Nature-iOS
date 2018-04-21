//
//  DataHelper.swift
//  Nature
//
//  Created by Oliver Kulpakko on 18/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import Foundation

class DataHelper {
	
	/// Fetch categories for a specified country, or if an empty country is given, for all countries.
	/// The response can be very big, especially when fetching for all countries.
	///
	/// - Parameters:
	///   - completion: An optional array of Category, and an optional error.
	class func fetchCategories(for country: String = "", completion: @escaping (_ result: [Category]?, Error?) -> Void) {
		guard let url = URL(string: "https://eaststudios.net/api/Nature/category/?country=" + country) else {
			completion(nil, nil)
			return
		}
		
		API.get(url, type: [Category].self, completion: { categories, error in
			if var categories = categories {
				for categoryIndex in 0 ..< categories.count {
					for itemIndex in 0 ..< categories[categoryIndex].items.count {
						categories[categoryIndex].items[itemIndex].category = categories[categoryIndex]
					}
				}
				completion(categories, error)
				return
			}
			completion(categories, error)
		})
	}
	
	class func fetchCountries(completion: @escaping (_ result: [Country]?, Error?) -> Void) {
		guard let url = URL(string: "https://eaststudios.net/api/Nature/country/") else {
			completion(nil, nil)
			return
		}
		
		API.get(url, type: [Country].self, completion: completion)
	}
}
