//
//  SettingsViewController.swift
//  Nature
//
//  Created by Oliver Kulpakko on 18/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

	//MARK: View Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	// MARK: BaseViewController
	
	override func setInterfaceStrings() {
		super.setInterfaceStrings()
		
		title = "settings.title".localized
	}
	
	override func setupViews() {
		super.setupViews()
		
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
	}
	
	override func reloadData() {
		super.reloadData()
		DataHelper.fetchCountries(completion: { countries, error in
			guard let countries = countries, error == nil else {
				self.showError(error)
				return
			}
			
			self.countries = countries
			
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		})
	}
	
	// MARK: UITableViewDelegate
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	// MARK: UITableViewDataSource
	
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "settings.available-countries.title".localized
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return countries.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
		
		let country = countries[indexPath.row]
		
		cell.textLabel?.text = country.country
		cell.detailTextLabel?.text = String(format: "settings.categories.available.%i".localized, country.count)
		
		return cell
	}
	
	// MARK: Navigation
	
	@objc func toSettings() {
		let settingsViewController = SettingsViewController()
		let navigationController = UINavigationController(rootViewController: settingsViewController)
		settingsViewController.addDoneButton()
		
		present(navigationController, animated: true)
	}
	
	// MARK: Instance Functions
	
	// MARK: Instance Variables
	
	var countries = [Country]()
	
	// MARK: IBOutlets
	
	@IBOutlet var tableView: UITableView!
}
