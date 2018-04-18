//
//  API.swift
//  Nature
//
//  Created by Oliver Kulpakko on 18/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import Foundation

class API {
	class func get<T: Decodable>(_ url: URL, type: T.Type, completion: @escaping (_ result: T?, Error?) -> Void) {
		get(url, completion: { data, error in
			guard let data = data else {
				completion(nil, error)
				return
			}
			
			let decoder = JSONDecoder()
			
			do {
				let result = try decoder.decode(type, from: data)
				completion(result, nil)
			} catch {
				completion(nil, error)
			}
		})
	}
	
	class func get(_ url: URL, completion: @escaping (_ result: Data?, Error?) -> Void) {
		URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
			completion(data, error)
		}).resume()
	}
}
