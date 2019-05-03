//
//  RemoteService+Items.swift
//  Nature
//
//  Created by Oliver Kulpakko on 03/05/2019.
//  Copyright © 2019 Oliver Kulpakko. All rights reserved.
//

import Foundation

extension RemoteService {
	/// Fetch all available items for a category.
	func fetchItems(_ category: String, completion: @escaping (Result<[Item], Error>) -> Void) {
		makeRequest(String(format: "/categories/%@/items", category),
					method: .get,
					body: nil,
					responseType: [Item].self,
					cacheName: String(format: "Items:%@", category),
					completion: completion)
	}
}
