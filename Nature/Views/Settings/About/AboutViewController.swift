//
//  AboutViewController.swift
//  Nature
//
//  Created by Oliver Kulpakko on 21/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import UIKit
import SafariServices

class AboutViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

	//MARK: View Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	// MARK: BaseViewController

	override func setInterfaceStrings() {
		super.setInterfaceStrings()

		title = "about.title".localized
	}

	override func setupViews() {
		super.setupViews()

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
		rows = [
			.rate,
			.support,
			.acknowledgements
		]
	}

	// MARK: UITableViewDelegate

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		switch rows[indexPath.row] {
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
	}

	// MARK: UITableViewDataSource

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return rows.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		let row = rows[indexPath.row]

		let rowString = "about.row." + String(describing: row)

		cell.textLabel?.text = rowString.localized

		cell.imageView?.image = UIImage(named: rowString)

		cell.textLabel?.textColor = Theme.current.cellTextColor
		cell.backgroundColor = Theme.current.cellBackgroundColor

		return cell
	}

	func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		return ("© Oliver Kulpakko, Version " + UIApplication.shared.formattedVersion)
	}

	// MARK: Navigation

	@objc func toSettings() {
		let settingsViewController = SettingsViewController()
		let navigationController = UINavigationController(rootViewController: settingsViewController)
		settingsViewController.addDoneButton()

		present(navigationController, animated: true)
	}

	var rows = [Row]()

	enum Row {
		case rate
		case support
		case acknowledgements
	}

	// MARK: Instance Functions

	// MARK: Instance Variables

	var availableCountries = [Country]()

	// MARK: IBOutlets

	@IBOutlet var tableView: UITableView!
}
