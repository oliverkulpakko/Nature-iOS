//
//  DataHelper.swift
//  Nature
//
//  Created by Oliver Kulpakko on 18/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import Foundation

class DataHelper {
	class func fetchCategories(completion: (_ result: [Category]?, Error?) -> Void) {
		guard let url = Bundle.main.url(forResource: "Categories", withExtension: "json") else {
			completion(nil, nil)
			return
		}
		
		do {
			let data = try Data(contentsOf: url)
			
			let categories = try JSONDecoder().decode([Category].self, from: data)
			
			completion(categories, nil)
		} catch {
			completion(nil, error)
		}
	}
}
