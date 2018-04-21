//
//  MapTileCache.swift
//  Topo Maps
//
//  Created by Oliver Kulpakko on 29.3.2018.
//  Copyright © 2018 East Studios. All rights reserved.
//

import Foundation
import MapKit

class MapTileCache {
	class func storeTile(_ data: Data, path: MKTileOverlayPath, mapTypeID: String) {
		let directoryName = "tiles/" + mapTypeID
		
		let success = createDirectory(directoryName)
		
		if success {
			guard let url = url(path: path, mapTypeID: mapTypeID) else {
				return
			}
			
			try? data.write(to: url)
		}
	}
	
	class func fetchTile(_ path: MKTileOverlayPath, mapTypeID: String, completion: @escaping (_ result: Data?) -> Void) {
		guard let url = url(path: path, mapTypeID: mapTypeID) else {
			completion(nil)
			print("Can't fetch tile at \(path), with map type \(mapTypeID). URL is nil.")
			return
		}
		
		let data = try? Data(contentsOf: url)
		
		completion(data)
	}
	
	private class func url(path: MKTileOverlayPath, mapTypeID: String) -> URL? {
		var url = cachesDirectory
		let directoryName = "tiles/" + mapTypeID
		
		let fileName = String(path.z) + "-" + String(path.x) + "-" + String(path.y)
		
		url?.appendPathComponent(directoryName, isDirectory: true)
		url?.appendPathComponent(fileName)
		url?.appendPathExtension("png")
		
		return url
	}
	
	private class func createDirectory(_ name: String) -> Bool {
		guard var url = cachesDirectory else {
			return false
		}
		
		url.appendPathComponent(name, isDirectory: true)
		
		try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
		return true
	}
	
	private static var cachesDirectory: URL? {
		return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
	}
}
