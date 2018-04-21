//
//  BookmarksHelper.swift
//  Nature
//
//  Created by Oliver Kulpakko on 21/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import Foundation

class BookmarkHelper {
	class func fetchMapBookmarks(for item: Item, completion: @escaping (_ result: [MapBookmark]?) -> Void) {
		let fileName = "MapBookmarks" + ":" + item.id
		
		let bookmarks = Storage.retrieve(fileName, from: .documents, as: [MapBookmark].self)
		
		completion(bookmarks)
	}
	
	class func storeMapBookmarks(for item: Item, bookmarks: [MapBookmark]) {
		let fileName = "MapBookmarks" + ":" + item.id
		
		Storage.store(bookmarks, to: .documents, as: fileName)
	}
	
	class func createMapBookmark(_ bookmark: MapBookmark, for item: Item, completion: @escaping () -> Void) {
		fetchMapBookmarks(for: item, completion: { bookmarks in
			var bookmarks = (bookmarks ?? [])
			
			bookmarks.append(bookmark)
			storeMapBookmarks(for: item, bookmarks: bookmarks)
			
			completion()
		})
	}
}
