//
//  DataHelper.swift
//  Nature
//
//  Created by Oliver Kulpakko on 18/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import Foundation

class DataHelper {
	

	/// 	/// Fetch categories for a specified country, or if an empty country is given, for all countries.
	/// The response can be very big, especially when fetching for all countries.
	///
	/// - Parameters:
	///   - forceRefresh: Should the data be forcefully updated, and not fetched from cache. A cached version will still be returned if there was an error loading the data.
	///   - completion: An optional array of Category, and an optional error.
	class func fetchCategories(for country: String = "", forceRefresh: Bool, completion: @escaping (_ result: [Category]?, Error?) -> Void) {
		if let cachedCategories = Storage.retrieve("Categories", from: .caches, as: [Category].self), !forceRefresh {
			completion(cachedCategories, nil)
			return
		}
		
		guard let url = URL(string: "https://eaststudios.net/api/Nature/category/?country=" + country) else {
			completion(nil, nil)
			return
		}
		
		API.get(url, type: [Category].self, completion: { categories, error in
			if let categories = categories {
				Storage.store(categories, to: .caches, as: "Categories")
				completion(categories, nil)
			} else {
				if forceRefresh {
					fetchCategories(forceRefresh: false, completion: completion) // Try one more time, without force refreshing
				} else {
					completion(nil, error)
				}
			}
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
