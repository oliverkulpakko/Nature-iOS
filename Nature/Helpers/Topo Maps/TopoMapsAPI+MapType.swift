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
		let cachedFileName = "MapTypes.json"
		let cachedMapTypes = Storage.retrieve(cachedFileName, from: .caches, as: [MapType].self)
		completion(cachedMapTypes, nil)
		
		guard let url = URL(string: baseUrl(for: .v1) + "/GetMapType/") else {
			completion(nil, nil)
			return
		}
		
		get(url, type: [MapType].self, completion: { mapTypes, error in
			completion(mapTypes, error)
			
			Storage.store(mapTypes, to: .caches, as: cachedFileName)
		})
	}
}
