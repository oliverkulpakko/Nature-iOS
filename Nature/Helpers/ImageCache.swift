//
//  ImageCache.swift
//  Nature
//
//  Created by Oliver Kulpakko on 18/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import UIKit

class ImageCache {
	class func fetchImage(from url: String, id: String, completion: @escaping (_ result: UIImage?, Error?) -> Void) {
		if let image = getCachedImage(id: id) {
			completion(image, nil)
			return
		}

		guard let url = URL(string: url) else {
			completion(nil, nil)
			return
		}
		
		URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
			guard let data = data, error == nil else {
				completion(nil, error)
				return
			}
			
			if let image = UIImage(data: data) {
				completion(image, nil)
				
				storeImage(image, as: id)
			} else {
				completion(nil, nil)
			}
		}).resume()
	}
	
	class func getCachedImage(id: String) -> UIImage? {
		guard let url = cacheURL(for: id) else {
			return nil
		}
		
		guard let data = try? Data(contentsOf: url) else {
			return nil
		}
		
		return UIImage(data: data)
	}
	
	class func storeImage(_ image: UIImage, as id: String) {
		guard let url = cacheURL(for: id) else {
			return
		}
		
		let data = UIImageJPEGRepresentation(image, 0.7)
		try? data?.write(to: url)
	}
	
	class func cacheURL(for id: String) -> URL? {
		var cachesUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
		
		cachesUrl?.appendPathComponent("ImageCache")
		cachesUrl?.appendPathComponent(id)
		
		return cachesUrl
	}
}
