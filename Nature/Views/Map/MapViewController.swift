//
//  MapViewController.swift
//  Nature
//
//  Created by Oliver Kulpakko on 21/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: BaseViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
	
	//MARK: View Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "map.bookmarks.title".localized
	}
	
	// MARK: BaseViewController
	
	override func setupViews() {
		super.setupViews()
		
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
	}
	
	override func updateTheme() {
		super.updateTheme()
		
		view.backgroundColor = Theme.current.tableViewBackgroundColor
		
		tableView.separatorColor = Theme.current.tableViewSeparatorColor
		tableView.reloadData()
	}
	
	override func reloadData() {
		super.reloadData()
		
		bookmarks = [
			MapBookmark(title: "test", subtitle: "test", coordinate: CLLocationCoordinate2D(latitude: 60, longitude: 24))
		]
		
		mapView.removeAnnotations(mapView.annotations)
		mapView.addAnnotations(bookmarks)
		
		tableView.reloadData()
	}
	
	// MARK: UITableViewDelegate
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		let bookmark = bookmarks[indexPath.row]
		
		mapView.selectAnnotation(bookmark, animated: true)
	}
	
	// MARK: UITableViewDataSource
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return bookmarks.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
		
		let bookmark = bookmarks[indexPath.row]
		
		cell.textLabel?.text = bookmark.title
		cell.detailTextLabel?.text = bookmark.subtitle
		
		cell.textLabel?.textColor = Theme.current.cellTextColor
		cell.detailTextLabel?.textColor = Theme.current.cellTextColor
		cell.backgroundColor = Theme.current.cellBackgroundColor
		
		return cell
	}
	
	// MARK: Instance Variables
	
	var item: Item!
	
	var bookmarks = [MapBookmark]()
	
	// MARK: IBOutlets
	
	@IBOutlet var mapView: MKMapView!
	@IBOutlet var tableView: UITableView!
}
