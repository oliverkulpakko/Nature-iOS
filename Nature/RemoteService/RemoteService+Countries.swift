//
//  RemoteService+Countries.swift
//  Nature
//
//  Created by Oliver Kulpakko on 03/05/2019.
//  Copyright © 2019 Oliver Kulpakko. All rights reserved.
//

import Foundation

extension RemoteService {
	/// Fetch all available countries.
	func fetchCountries(completion: @escaping (Result<[Country], Error>) -> Void) {
		makeRequest("/countries",
					method: .get,
					body: nil,
					responseType: [Country].self,
					cacheName: "Countries",
					completion: completion)
	}
}
