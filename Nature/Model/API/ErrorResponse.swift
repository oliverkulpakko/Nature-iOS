//
//  ErrorResponse.swift
//  TopoMaps6
//
//  Created by Oliver Kulpakko on 01/10/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import Foundation

struct ErrorResponse: Decodable, Error {
	let status: String

	static let unknown = ErrorResponse(status: "UNKNOWN_STATE")
}

extension ErrorResponse: LocalizedError {
	public var errorDescription: String? {
		return ("api-error." + status).localized
	}
}
