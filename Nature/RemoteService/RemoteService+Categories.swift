//
//  RemoteService+Categories.swift
//  Nature
//
//  Created by Oliver Kulpakko on 03/05/2019.
//  Copyright © 2019 Oliver Kulpakko. All rights reserved.
//

import Foundation

extension RemoteService {
	/// Fetch all available categories for a country.
	func fetchCategories(_ country: String?, completion: @escaping (Result<[Category], Error>) -> Void) {
		makeRequest(String(format: "/categories/%@", country ?? ""),
					method: .get,
					body: nil,
					responseType: [Category].self,
					cacheName: String(format: "Categories:%@", country ?? ""),
					completion: completion)
	}
}
