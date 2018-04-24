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
	
	override func updateTheme() {
		super.updateTheme()

		self.view.backgroundColor = Theme.current.tableViewBackgroundColor
		self.tableView.separatorColor =  Theme.current.tableViewSeparatorColor
		self.tableView.reloadData()
	}
	
	override func reloadData() {
		super.reloadData()
		settings = [
			Setting(title: "show-latin-name", userDefaultsKey: "ItemShowLatinNameWhenSubtitleIsUnavailable"),
			Setting(title: "dark-mode", userDefaultsKey: "UseDarkTheme"),
			Setting(title: "simple-item-view", userDefaultsKey: "UseSimpleItemView"),
			Setting(title: "disable-map-overlay", userDefaultsKey: "DisableMapOverlay"),
			Setting(title: "hide-search-when-scrolling", userDefaultsKey: "HideSearchWhenScrolling")
		]

		aboutRows = [
			.rate,
			.support,
			.acknowledgements
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
		case Section.about.rawValue:
			return "settings.about.title".localized
		default:
			return nil
		}
	}

	func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		if section == Section.about.rawValue {
			return ("© Oliver Kulpakko, Version " + UIApplication.shared.formattedVersion)
		}

		return nil
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
		case Section.about.rawValue:
			return 3
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

			cell.selectionStyle = .none

			let setting = settings[indexPath.row]
			
			cell.titleLabel.text = ("settings." + setting.title).localized
			cell.switch.isOn = UserDefaults.standard.bool(forKey: setting.userDefaultsKey)
			
			cell.didToggle = {
				UserDefaults.standard.set(cell.switch.isOn, forKey: setting.userDefaultsKey)
			}
			
			cell.titleLabel.textColor = Theme.current.cellTextColor
			
			cell.iconImageView.image = UIImage(named: "settings." + setting.title)
			cell.iconImageView.layer.cornerRadius = (cell.iconImageView.bounds.height * 0.2237)

			cell.backgroundColor = Theme.current.cellBackgroundColor
			
			return cell
		case Section.availableCountries.rawValue:
			let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")

			cell.selectionStyle = .none
			
			let country = availableCountries[indexPath.row]
			
			cell.textLabel?.text = country.localizedCountry
			cell.detailTextLabel?.text = String(format: "settings.categories.available.%i".localized, country.count)
			cell.imageView?.image = UIImage(named: country.code)

			cell.textLabel?.textColor = Theme.current.cellTextColor
			cell.detailTextLabel?.textColor = Theme.current.cellTextColor
			cell.backgroundColor = Theme.current.cellBackgroundColor
			
			return cell
		case Section.about.rawValue:
			let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
			let row = ("settings.about." + String(describing: aboutRows[indexPath.row]))

			cell.accessoryType = .disclosureIndicator
			
			cell.textLabel?.text = row.localized

			cell.imageView?.image = UIImage(named: row)

			cell.textLabel?.textColor = Theme.current.cellTextColor
			cell.backgroundColor = Theme.current.cellBackgroundColor

			return cell
		default: break
		}
		
		return UITableViewCell()
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch indexPath.section {
		case Section.settings.rawValue:
			return 50
		default:
			return 44
		}
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
		let title: String
		let userDefaultsKey: String
	}

	enum AboutRow {
		case rate
		case support
		case acknowledgements
	}

	enum Section: Int {
		case settings
		case availableCountries
		case about

		case count
	}
	
	// MARK: Instance Functions
	
	// MARK: Instance Variables

	var aboutRows = [AboutRow]()
	var availableCountries = [Country]()
	
	// MARK: IBOutlets
	
	@IBOutlet var tableView: UITableView!
}
