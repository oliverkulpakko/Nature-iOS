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
		
		tableView.register(UINib(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "SwitchCell")
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
	}
	
	override func reloadData() {
		super.reloadData()
		settings = [
			Setting(name: "Show Latin Name", userDefaultsKey: "ItemShowLatinNameWhenSubtitleIsUnavailable")
		]
		
		DataHelper.fetchCountries(completion: { countries, error in
			guard let countries = countries, error == nil else {
				self.showError(error)
				return
			}
			
			self.availableCountries = countries
			
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
		switch section {
		case Section.settings.rawValue:
			return "settings.title".localized
		case Section.availableCountries.rawValue:
			return "settings.available-countries.title".localized
		default:
			return nil
		}
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return Section.count.rawValue
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case Section.settings.rawValue:
			return settings.count
		case Section.availableCountries.rawValue:
			return availableCountries.count
		default:
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.section {
		case Section.settings.rawValue:
			guard let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as? SwitchCell else {
				break
			}
			
			let setting = settings[indexPath.row]
			
			cell.titleLabel.text = setting.name
			cell.switch.isOn = UserDefaults.standard.bool(forKey: setting.userDefaultsKey)
			
			cell.didToggle = {
				UserDefaults.standard.set(cell.switch.isOn, forKey: setting.userDefaultsKey)
			}
			
			return cell
		case Section.availableCountries.rawValue:
			let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
			
			let country = availableCountries[indexPath.row]
			
			cell.textLabel?.text = country.country
			cell.detailTextLabel?.text = String(format: "settings.categories.available.%i".localized, country.count)
			
			return cell
		default: break
		}
		
		return UITableViewCell()
	}
	
	// MARK: Navigation
	
	@objc func toSettings() {
		let settingsViewController = SettingsViewController()
		let navigationController = UINavigationController(rootViewController: settingsViewController)
		settingsViewController.addDoneButton()
		
		present(navigationController, animated: true)
	}
	
	var settings = [Setting]()
	
	struct Setting {
		let name: String
		let userDefaultsKey: String
	}
	
	enum Section: Int {
		case settings
		case availableCountries
		
		case count
	}
	
	// MARK: Instance Functions
	
	// MARK: Instance Variables
	
	var availableCountries = [Country]()
	
	// MARK: IBOutlets
	
	@IBOutlet var tableView: UITableView!
}
