//
//  MapViewController.swift
//  Nature
//
//  Created by Oliver Kulpakko on 21/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: BaseViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
	
	//MARK: View Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "map.title".localized
		
		locationManager.requestWhenInUseAuthorization()
	}
	
	// MARK: BaseViewController
	
	override func setupViews() {
		super.setupViews()
		
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
		tableView.tableFooterView = UIView() // Remove empty separators
		
		let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(sender:)))
		longPressRecognizer.minimumPressDuration = 1
		
		mapView.addGestureRecognizer(longPressRecognizer)
		
		let createButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showNewBookmarkAlert))
		navigationItem.rightBarButtonItems?.append(createButton)
	}
	
	override func updateTheme() {
		super.updateTheme()
		
		view.backgroundColor = Theme.current.tableViewBackgroundColor
		
		tableView.separatorColor = Theme.current.tableViewSeparatorColor
		tableView.reloadData()
	}
	
	override func reloadData() {
		super.reloadData()
		
		if item == nil {
			done()
			return
		}
		
		if !UserDefaults.standard.bool(forKey: "DisableMapOverlay") {
			setMapType()
		}
		
		BookmarkHelper.fetchMapBookmarks(for: item, completion: { [weak self] bookmarks in
			if let bookmarks = bookmarks {
				self?.bookmarks = bookmarks
				
				DispatchQueue.main.async {
					self?.mapView.removeAnnotations(self?.mapView.annotations ?? [])
					self?.mapView.addAnnotations(bookmarks)
					self?.tableView.reloadData()
				}
			}
		})
		
	}
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation is MKUserLocation { return nil }
		
		let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
		pin.canShowCallout = true
		pin.pinTintColor = item.category?.color
		
		return pin
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
	
	// MARK: CLLocationManagerDelegate
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		switch status {
		case .authorizedWhenInUse, .authorizedAlways:
			locationManager.startUpdatingLocation()
		case .notDetermined:
			locationManager.requestWhenInUseAuthorization() // This shouldn't get called as it's already called in viewDidLoad.
		case .denied, .restricted:
			print("Location not allowed") // TODO: Show a prompt to go to settings
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		/*guard let location = locations.first else {
			return
		}*/
		
		if waitingForBookmarkLocation {
			waitingForBookmarkLocation = false
			createBookmarkToCurrentLocation()
		}
		
		if waitingForMapTypeLocation {
			waitingForMapTypeLocation = false
			setMapType()
		}
	}
	
	// MARK: Instance Functions
	
	@objc func showNewBookmarkAlert() {
		let alert = UIAlertController(title: "map.alert.new-bookmark-current-location.title".localized,
									  message: "map.alert.new-bookmark-current-location.message".localized,
									  preferredStyle: .alert)
		
		let currentLocationAction = UIAlertAction(title: "map.alert.new-bookmark-current-location.create-button".localized, style: .default, handler: { _ in
			self.createBookmarkToCurrentLocation()
		})
		alert.addAction(currentLocationAction)
		
		alert.addAction(UIAlertAction(title: "alert.button.cancel".localized, style: .cancel, handler: nil))
		
		present(alert, animated: true)
	}
	
	func createBookmarkToCurrentLocation() {
		guard let location = locationManager.location else {
			waitingForBookmarkLocation = true
			locationManager.requestLocation()
			print("Waiting for location...") // TODO: Disable interaction somehow, maybe with a HUD...
			return
		}
		
		showCreateBookmarkAlert(coordinate: location.coordinate)
	}
	
	func showCreateBookmarkAlert(coordinate: CLLocationCoordinate2D) {
		let alert = UIAlertController(title: "map.alert.new-bookmark.title".localized,
									  message: String(coordinate.latitude) + ", " + String(coordinate.longitude),
									  preferredStyle: .alert)
		
		alert.addTextField(configurationHandler: { textField in
			textField.placeholder = "map.alert.new-bookmark.textfield.placeholder".localized
			textField.textAlignment = .center
			textField.autocapitalizationType = .sentences
		})
		
		let currentLocationAction = UIAlertAction(title: "map.alert.new-bookmark.button".localized, style: .default, handler: { _ in
			guard let text = alert.textFields?.first?.text, !text.isEmpty else {
				self.showAlert(title: "map.alert.new-bookmark-name-empty.title".localized)
				return
			}
			
			let bookmark = MapBookmark(title: text, coordinate: coordinate)
			BookmarkHelper.createMapBookmark(bookmark, for: self.item, completion: { [weak self] in
				self?.reloadData()
			})
		})
		alert.addAction(currentLocationAction)
		
		alert.addAction(UIAlertAction(title: "alert.button.cancel".localized, style: .cancel, handler: nil))
		
		present(alert, animated: true)
	}
	
	@objc func didLongPress(sender: UILongPressGestureRecognizer) {
		let touchPoint = sender.location(in: mapView)
		let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
		
		showCreateBookmarkAlert(coordinate: coordinate)
	}
	
	// MARK: Map Overlay
	
	func setMapType() {
		let mapType = Storage.retrieve("MapType", from: .caches, as: MapType.self)
		
		if let mapType = mapType {
			let tileOverlay = TileOverlay(mapTypeID: mapType.identifier)
			DispatchQueue.main.async {
				self.mapView.add(tileOverlay, level: .aboveRoads)
				self.mapCopyrightLabel.text = "© " + mapType.copyright
			}
		} else {
			TopoMapsAPI.fetchMapTypes(completion: { [weak self] mapTypes, _ in
				if let mapTypes = mapTypes {
					if let location = self?.locationManager.location {
						CLGeocoder().reverseGeocodeLocation(location, completionHandler: { placemarks, _ in
							guard let placemark = placemarks?.first else {
								return
							}
							
							let country = placemark.isoCountryCode
							
							if let mapType = mapTypes.filter({ $0.countryCode == country && $0.name == "topo" }).first {
								Storage.store(mapType, to: .caches, as: "MapType")
								self?.setMapType()
							}
						})
					} else {
						self?.waitingForMapTypeLocation = true
					}
				}
			})
		}
	}
	
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		if overlay is MKTileOverlay {
			let renderer = MKTileOverlayRenderer(overlay: overlay)
			return renderer
		}
		return MKOverlayRenderer(overlay: overlay)
	}
	
	// MARK: Instance Variables
	
	var locationManager = CLLocationManager()
	var waitingForBookmarkLocation = false
	var waitingForMapTypeLocation = false
	
	var item: Item!
	var bookmarks = [MapBookmark]()
	
	// MARK: IBOutlets
	
	@IBOutlet var mapView: MKMapView!
	@IBOutlet var mapCopyrightLabel: UILabel!
	
	@IBOutlet var tableView: UITableView!
}
