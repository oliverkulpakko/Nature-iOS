//
//  ItemsViewController.swift
//  Nature
//
//  Created by Oliver Kulpakko on 18/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import UIKit
import Imaginary

class ItemsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

	//MARK: View Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()

		searchController.searchResultsUpdater = self
		searchController.searchBar.placeholder = "items.search.placeholder".localized
		definesPresentationContext = true
		
		if #available(iOS 11.0, *) {
			navigationItem.searchController = searchController
			navigationItem.hidesSearchBarWhenScrolling = false
			searchController.obscuresBackgroundDuringPresentation = false
		} else {
			tableView.tableHeaderView = searchController.searchBar
		}
	}
	
	// MARK: BaseViewController
	
	override func setupViews() {
		super.setupViews()
		
		tableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
	}
	
	override func reloadData() {
		super.reloadData()
		
		if category == nil {
			done()
			return
		}
		
		title = category.name
	}
	
	// MARK: UITableViewDelegate
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		let item: Item
		if isSearching {
			item = filteredItems[indexPath.row]
		} else {
			item = category.items[indexPath.row]
		}
		
		let itemViewController = ItemViewController()
		itemViewController.item = item
		
		navigationController?.pushViewController(itemViewController, animated: true)
	}
	
	// MARK: UITableViewDataSource
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if isSearching {
			return filteredItems.count
		}
		
		return category.items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as? ItemCell else {
			return UITableViewCell()
		}
		
		let item: Item
		if isSearching {
			item = filteredItems[indexPath.row]
		} else {
			item = category.items[indexPath.row]
		}
		
		cell.titleLabel.text = item.title
		cell.subtitleLabel.text = item.subtitle
		cell.backgroundImageView.image = nil
		if let url = URL(string: item.image?.url ?? "") {
			cell.backgroundImageView.setImage(url: url)
		}
		
		return cell
	}
	
	// MARK: UISearchResultsUpdating
	
	func updateSearchResults(for searchController: UISearchController) {
		filterItems(for: searchController.searchBar.text ?? "")
	}
	
	// MARK: Instance Functions
	
	func filterItems(for text: String) {
		filteredItems = category.items.filter({ item -> Bool in
			return item.title.lowercased().contains(text.lowercased())
		})
		
		tableView.reloadData()
	}
	
	// MARK: Calculated Properties
	
	var isSearchBarEmpty: Bool {
		return (searchController.searchBar.text?.isEmpty ?? true)
	}
	
	var isSearching: Bool {
		return searchController.isActive && !isSearchBarEmpty
	}
	
	// MARK: Instance Variables
	
	var searchController = UISearchController(searchResultsController: nil)
	
	var filteredItems = [Item]()
	var category: Category!
	
	// MARK: IBOutlets
	
	@IBOutlet var tableView: UITableView!
}
