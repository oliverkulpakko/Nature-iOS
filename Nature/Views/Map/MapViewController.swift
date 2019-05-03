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

class MapViewController: BaseViewController {
	
	//MARK: Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "map.title".localized

		locationManager.delegate = self
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
		
		view.backgroundColor = Theme.current.viewBackgroundColor
		
		tableView.separatorColor = Theme.current.tableViewSeparatorColor
		tableView.reloadData()
	}
	
	override func reloadData() {
		super.reloadData()
		
		if !UserDefaults.standard.bool(forKey: "DisableMapOverlay") {
			setMapType()
		}
		
		BookmarkHelper.fetchMapBookmarks(for: item, completion: { bookmarks in
			self.bookmarks = bookmarks

			DispatchQueue.main.async {
				self.mapView.removeAnnotations(self.mapView.annotations)
				self.mapView.addAnnotations(bookmarks)
				self.tableView.reloadData()
			}
		})
		
	}
	
	override func saveAnalytics() {
		Analytics.log(action: "OpenView", error: "", data1: String(describing: type(of: self)), data2: item.id)
	}

	// MARK: Initializers

	init(item: Item) {
		self.item = item
		super.init()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: Instance Methods
	
	@objc func showNewBookmarkAlert() {
		guard locationManager.isAuthorized else {
			locationManager(locationManager, didChangeAuthorization: .denied)
			return
		}

		let alert = UIAlertController(title: "map.alert.new-bookmark-current-location.title".localized,
									  message: "map.alert.new-bookmark-current-location.message".localized,
									  preferredStyle: .alert)
		
		let currentLocationAction = UIAlertAction(title: "map.alert.new-bookmark-current-location.create-button".localized, style: .default, handler: { _ in
			self.createBookmarkToCurrentLocation()
		})

		alert.addAction(currentLocationAction)
		
		alert.addCancelAction()
		
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
									  message: String(format: "%.5f, %.5f", coordinate.latitude, coordinate.longitude),
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
			BookmarkHelper.createMapBookmark(bookmark, for: self.item, completion: {
				self.reloadData()
				
				Analytics.log(action: "CreateMapBookmark", error: "", data1: self.item.id, data2: "")
			})
		})
		alert.addAction(currentLocationAction)
		
		alert.addCancelAction()
		
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
				self.mapCopyrightLabel.isHidden = false
			}
		} else {
			TopoMapsAPI.fetchMapTypes(completion: { mapTypes, _ in
				if let mapTypes = mapTypes {
					if let location = self.locationManager.location {
						CLGeocoder().reverseGeocodeLocation(location, completionHandler: { placemarks, _ in
							guard let placemark = placemarks?.first else {
								return
							}
							
							let country = placemark.isoCountryCode
							
							if let mapType = mapTypes.filter({ $0.countryCode == country && $0.name == "topo" }).first {
								Storage.store(mapType, to: .caches, as: "MapType")
								self.setMapType()
							}
						})
					} else {
						self.waitingForMapTypeLocation = true
					}
				}
			})
		}
	}
	
	// MARK: Stored Properties
	
	var locationManager = CLLocationManager()
	var waitingForBookmarkLocation = false
	var waitingForMapTypeLocation = false
	
	var item: Item
	var bookmarks = [MapBookmark]()
	
	// MARK: IBOutlets
	
	@IBOutlet var mapView: MKMapView!
	@IBOutlet var mapCopyrightLabel: UILabel!
	
	@IBOutlet var tableView: UITableView!
}

extension MapViewController: MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation is MKUserLocation { return nil }

		let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
		pin.canShowCallout = true
		pin.pinTintColor = Theme.current.tintColor

		return pin
	}

	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		if overlay is MKTileOverlay {
			let renderer = MKTileOverlayRenderer(overlay: overlay)
			return renderer
		}
		
		return MKOverlayRenderer(overlay: overlay)
	}
}

extension MapViewController: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		switch status {
		case .authorizedWhenInUse, .authorizedAlways:
			locationManager.startUpdatingLocation()
		case .notDetermined:
			locationManager.requestWhenInUseAuthorization()
		case .denied, .restricted:
			let alert = UIAlertController(title: "map.location-not-allowed.title".localized,
										  message: "map.location-not-allowed.message".localized,
										  preferredStyle: .alert)

			alert.addAction(UIAlertAction(title: "map.location-not-allowed.action".localized, style: .default, handler: { _ in
				if let url = URL(string: UIApplicationOpenSettingsURLString) {
					UIApplication.shared.open(url, options: [:], completionHandler: nil)
				}
			}))

			alert.addCancelAction()

			present(alert, animated: true)
		}

		Analytics.log(action: "LocationAuthorizationStatus", error: "", data1: String(describing: status), data2: "")
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

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		presentError(error)
	}
}

extension MapViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		let bookmark = bookmarks[indexPath.row]

		mapView.selectAnnotation(bookmark, animated: true)
	}
}

extension MapViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return bookmarks.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")

		let bookmark = bookmarks[indexPath.row]

		cell.textLabel?.text = bookmark.title
		cell.detailTextLabel?.text = bookmark.subtitle

		cell.textLabel?.textColor = Theme.current.textColor
		cell.detailTextLabel?.textColor = Theme.current.textColor
		cell.backgroundColor = Theme.current.cellBackgroundColor

		return cell
	}
}

extension MapViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
	func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
		let attributes: [NSAttributedString.Key: Any] = [
			.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize + 4)
		]

		return NSAttributedString(string: "map.empty.title".localized, attributes: attributes)
	}
}
