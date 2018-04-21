//
//  TileOverlay.swift
//  Topo Maps
//
//  Created by Oliver Kulpakko on 29.3.2018.
//  Copyright © 2018 East Studios. All rights reserved.
//

import MapKit

class TileOverlay: MKTileOverlay {
	var mapTypeID: String?
	
	override func loadTile(at path: MKTileOverlayPath, result: @escaping (Data?, Error?) -> Void) {
		if let identifier = mapTypeID {
			TopoMapsAPI.fetchTile(path, mapTypeID: identifier, completion: { data, error in
				result(data, error)
			})
		} else {
			print("Tile Overlay - Missing mapTypeID.")
			result(nil, nil)
		}
	}
	
	convenience init(mapTypeID: String) {
		self.init()
		self.mapTypeID = mapTypeID
	}
}
