//
//  AnalyticsViewController.swift
//  Nature
//
//  Created by Oliver Kulpakko on 24/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import UIKit

class AnalyticsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
	
	//MARK: View Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "analytics.title"
	}
	
	// MARK: BaseViewController
	
	override func setupViews() {
		super.setupViews()
		
		addDoneButton()
		
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
		
		Analytics.fetchData(completion: { data, error in
			guard let data = data, error == nil else {
				self.showError(error)
				return
			}
			
			self.items = data.items
			
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
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		
		let item = items[indexPath.row]
		
		cell.textLabel?.text = item.action
		cell.detailTextLabel?.text = item.data1
		
		return cell
	}
	
	// MARK: Instance Variables
	
	var searchController = UISearchController(searchResultsController: nil)
	
	var items = [AnalyticsItem]()
	
	// MARK: IBOutlets
	
	@IBOutlet var tableView: UITableView!
}
