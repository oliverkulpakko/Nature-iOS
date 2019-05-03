//
//  HTTPError.swift
//  TopoMaps6
//
//  Created by Oliver Kulpakko on 15/10/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import Foundation

struct HTTPError: Error, LocalizedError {
	let response: URLResponse

	public var errorDescription: String? {
		let httpUrlResponse = response as? HTTPURLResponse

		return HTTPURLResponse.localizedString(forStatusCode: httpUrlResponse?.statusCode ?? 500)
	}
}
