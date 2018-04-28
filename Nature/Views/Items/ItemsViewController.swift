//
//  ItemsViewController.swift
//  Nature
//
//  Created by Oliver Kulpakko on 18/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import UIKit
import Imaginary

class ItemsViewController: BaseViewController {

	//MARK: View Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()

		searchController.searchResultsUpdater = self
		searchController.searchBar.placeholder = "items.search.placeholder".localized
		definesPresentationContext = true
		
		if #available(iOS 11.0, *) {
			navigationItem.searchController = searchController
			navigationItem.hidesSearchBarWhenScrolling = UserDefaults.standard.bool(forKey: "HideSearchWhenScrolling")
			searchController.obscuresBackgroundDuringPresentation = false
		} else {
			tableView.tableHeaderView = searchController.searchBar
		}
	}
	
	// MARK: BaseViewController
	
	override func setupViews() {
		super.setupViews()
		
		registerForPreviewing(with: self, sourceView: tableView)
		tableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
	}
	
	override func updateTheme() {
		super.updateTheme()
		
		searchController.searchBar.barStyle = Theme.current.barStyle
		searchController.searchBar.keyboardAppearance = Theme.current.keyboardAppearance
		
		view.backgroundColor = Theme.current.viewBackgroundColor
		
		tableView.separatorColor = Theme.current.tableViewSeparatorColor
		tableView.reloadData()
	}
	
	override func reloadData() {
		super.reloadData()
		
		if category == nil {
			done()
			return
		}
		
		title = category.name
	}
	
	override func saveAnalytics() {
		Analytics.log(action: "OpenView", error: "", data1: String(describing: type(of: self)), data2: category.id)
	}
	
	// MARK: Instance Functions
	
	func filterItems(for text: String) {
		filteredItems = category.items.filter({ item -> Bool in
			return item.searchText.lowercased().contains(text.lowercased())
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

extension ItemsViewController: UITableViewDelegate {
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
}

extension ItemsViewController: UITableViewDataSource {
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
		
		if item.subtitle.isEmpty && UserDefaults.standard.bool(forKey: "ItemShowLatinNameWhenSubtitleIsUnavailable") {
			cell.subtitleLabel.text = item.latinName
		}
		
		if let url = URL(string: item.image?.url ?? "") {
			cell.backgroundImageView.setImage(url: url)
		}
		
		return cell
	}
}

extension ItemsViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		filterItems(for: searchController.searchBar.text ?? "")
	}
}

extension ItemsViewController: UIViewControllerPreviewingDelegate {
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
		if let indexPath = tableView.indexPathForRow(at: location) {
			previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
			
			let item: Item
			if isSearching {
				item = filteredItems[indexPath.row]
			} else {
				item = category.items[indexPath.row]
			}
			
			let itemViewController = ItemViewController()
			itemViewController.item = item
			
			return itemViewController
		}
		return nil
	}
	
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
		navigationController?.pushViewController(viewControllerToCommit, animated: true)
	}
}
