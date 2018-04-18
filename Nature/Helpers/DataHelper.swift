//
//  DataHelper.swift
//  Nature
//
//  Created by Oliver Kulpakko on 18/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import Foundation

class DataHelper {
	class func fetchCategories(completion: @escaping (_ result: [Category]?, Error?) -> Void) {
		let country = "FI" // TODO
		
		guard let url = URL(string: "https://eaststudios.net/api/Nature/category/?country=" + country) else {
			completion(nil, nil)
			return
		}
		
		API.get(url, type: [Category].self, completion: completion)
	}
}
