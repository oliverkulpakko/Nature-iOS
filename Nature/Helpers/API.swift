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
		makeRequest(url: url, method: "GET", completion: { data, error in
			guard let data = data else {
				completion(nil, error)
				return
			}
			
			let decoder = JSONDecoder()
			if #available(iOS 10.0, *) {
				decoder.dateDecodingStrategy = .iso8601
			}
			
			do {
				let result = try decoder.decode(type, from: data)
				completion(result, nil)
			} catch {
				completion(nil, error)
			}
		})
	}
	
	class func makeRequest(url: URL, method: String, body: String? = nil, completion: ((_ result: Data?, Error?) -> Void)?) {
		var request = URLRequest(url: url)
		request.httpMethod = method.uppercased()
		
		request.httpBody = body?.data(using: .utf8)
		
		URLSession.shared.dataTask(with: request, completionHandler: { data, _, error in
			completion?(data, error)
		}).resume()
	}
}
