//
//  SettingsViewController.swift
//  Nature
//
//  Created by Oliver Kulpakko on 18/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {
	
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

		self.view.backgroundColor = Theme.current.viewBackgroundColor
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
			Setting(title: "hide-search-when-scrolling", userDefaultsKey: "HideSearchWhenScrolling"),
			Setting(title: "force-reload-data", userDefaultsKey: "ForceRefreshData"),
			Setting(title: "disable-analytics", userDefaultsKey: "DisableServerAnalytics")
		]

		RemoteService.shared.fetchCountries(completion: { result in
			DispatchQueue.main.async {
				switch result {
				case .success(let result):
					self.availableCountries = result
					self.tableView.reloadSections(IndexSet(integer: Section.availableCountries.rawValue), with: .automatic)
				case .failure(let error):
					self.presentError(error)
				}
			}
		})
	}
	
	// MARK: Stored Properties

	var settings = [Setting]()
	var availableCountries = [Country]()
	
	// MARK: IBOutlets
	
	@IBOutlet var tableView: UITableView!

	// MARK: Types

	struct Setting {
		let title: String
		let userDefaultsKey: String
	}

	enum AboutRow: Int, CaseIterable {
		case rate
		case support
		case acknowledgements
	}

	enum Section: Int, CaseIterable {
		case settings
		case availableCountries
		case about
	}
}

extension SettingsViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch Section.allCases[section] {
		case .settings:
			return "settings.title".localized
		case .availableCountries:
			return "settings.available-countries.title".localized
		case .about:
			return "settings.about.title".localized
		}
	}

	func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		switch Section.allCases[section] {
		case .about:
			let developerName = "Oliver Kulpakko"

			return String(format: "settings.about.copyright.%@.%@".localized, developerName, UIApplication.shared.formattedVersion)
		default:
			return nil
		}
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return Section.allCases.count
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch Section.allCases[section] {
		case .settings:
			return settings.count
		case .availableCountries:
			return availableCountries.count
		case .about:
			return AboutRow.allCases.count
		}
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch Section.allCases[indexPath.section] {
		case .settings:
			let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell

			cell.selectionStyle = .none

			let setting = settings[indexPath.row]

			cell.titleLabel.text = ("settings." + setting.title).localized
			cell.switch.isOn = UserDefaults.standard.bool(forKey: setting.userDefaultsKey)

			cell.didToggle = {
				UserDefaults.standard.set(cell.switch.isOn, forKey: setting.userDefaultsKey)

				Analytics.log(action: "SwitchSetting", error: "", data1: setting.title, data2: String(cell.switch.isOn))
			}

			cell.titleLabel.textColor = Theme.current.textColor

			cell.iconImageView.image = UIImage(named: "settings." + setting.title)
			cell.iconImageView.layer.cornerRadius = (cell.iconImageView.bounds.height * 0.2237)

			cell.backgroundColor = Theme.current.cellBackgroundColor

			return cell
		case .availableCountries:
			let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")

			cell.selectionStyle = .none

			let country = availableCountries[indexPath.row]

			cell.textLabel?.text = country.localized
			cell.detailTextLabel?.text = String(format: "settings.categories.available.%i".localized, country.categoryCount)
			cell.imageView?.image = UIImage(named: country.id)

			if UserDefaults.standard.string(forKey: "Country") == country.id {
				cell.accessoryType = .checkmark
			}

			cell.textLabel?.textColor = Theme.current.textColor
			cell.detailTextLabel?.textColor = Theme.current.textColor
			cell.backgroundColor = Theme.current.cellBackgroundColor

			return cell
		case .about:
			let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
			let row = ("settings.about." + String(describing: AboutRow.allCases[indexPath.row]))

			cell.accessoryType = .disclosureIndicator

			cell.textLabel?.text = row.localized

			cell.imageView?.image = UIImage(named: row)

			cell.textLabel?.textColor = Theme.current.textColor
			cell.backgroundColor = Theme.current.cellBackgroundColor

			return cell
		}
	}
}

extension SettingsViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		switch Section.allCases[indexPath.section] {
		case .availableCountries:
			let country = availableCountries[indexPath.row]

			UserDefaults.standard.set(country.id, forKey: "Country")
			UserDefaults.standard.set(true, forKey: "ForceRefreshData")

			tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
		case .about:
			switch AboutRow.allCases[indexPath.row]  {
			case .rate:
				RateHelper.openRate()
			case .support:
				let email = "support@eaststudios.net"

				guard let url = URL(string: "mailto:" + email) else {
					return
				}

				UIApplication.shared.openURL(url)
			case .acknowledgements:
				guard let url = URL(string: "https://eaststudios.net/Nature/Acknowledgements/") else {
					return
				}

				UIApplication.shared.openURL(url)
			}
		default:
			break
		}
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch Section.allCases[indexPath.section] {
		case .settings:
			return 50
		default:
			return 44
		}
	}
}
