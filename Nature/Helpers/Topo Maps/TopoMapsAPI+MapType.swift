//
//  API+MapType.swift
//  Topo Maps
//
//  Created by Oliver Kulpakko on 28.3.2018.
//  Copyright © 2018 East Studios. All rights reserved.
//

import Foundation

extension TopoMapsAPI {
	class func fetchMapTypes(completion: @escaping (_ result: [MapType]?, Error?) -> Void) {
		guard let url = URL(string: baseUrl(for: .v1) + "/GetMapType/?app=nature") else {
			completion(nil, nil)
			return
		}
		
		get(url, type: [MapType].self, completion: completion)
	}
}
