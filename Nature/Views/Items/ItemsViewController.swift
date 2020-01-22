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

	//MARK: Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()

		if #available(iOS 10.0, *) {
			collectionView.refreshControl = refreshControl
		}

		searchController.searchResultsUpdater = self
		searchController.searchBar.placeholder = "items.search.placeholder".localized
		definesPresentationContext = true
		
		if #available(iOS 11.0, *) {
			navigationItem.searchController = searchController
			navigationItem.hidesSearchBarWhenScrolling = UserDefaults.standard.bool(forKey: "HideSearchWhenScrolling")
			searchController.obscuresBackgroundDuringPresentation = false

		/*	navigationItem.rightBarButtonItems = [
				UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(toCamera))
			]*/
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		navigationController?.setToolbarHidden(true, animated: true)
	}
	
	// MARK: BaseViewController
	
	override func setupViews() {
		super.setupViews()
		
		registerForPreviewing(with: self, sourceView: collectionView)
		collectionView.register(UINib(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
	}
	
	override func updateTheme() {
		super.updateTheme()
		
		searchController.searchBar.barStyle = Theme.current.barStyle
		searchController.searchBar.keyboardAppearance = Theme.current.keyboardAppearance
		
		view.backgroundColor = Theme.current.viewBackgroundColor

		collectionView.reloadData()
	}
	
	override func reloadData() {
		super.reloadData()
		
		if let notice = category.notice, !UserDefaults.standard.bool(forKey: ("ShownNotice:" + category.id)) {
			showAlert(title: notice)
			UserDefaults.standard.set(true, forKey: ("ShownNotice:" + category.id))
		}
		
		title = category.name

		refreshControl.beginRefreshing()

		RemoteService.shared.fetchItems(category.id, completion: { result in
			DispatchQueue.main.async {
				self.refreshControl.endRefreshing()

				switch result {
				case .success(let result):
					self.items = result
					self.collectionView.reloadSections(IndexSet(integer: 0))
				case .failure(let error):
					self.presentError(error)
				}
			}
		})
	}

	// MARK: Initializers

	init(category: Category) {
		self.category = category
		super.init()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: Navigaiton

	@available(iOS 11.0, *)
	@objc func toCamera() {
		let viewController = ClassifierViewController(items: items, category: category)
		
		navigationController?.pushViewController(viewController, animated: true)
	}

	// MARK: Instance Methods
	
	func filterItems(for text: String) {
		filteredItems = items.filter({ item -> Bool in
			return item.searchText.lowercased().contains(text.lowercased())
		})
		
		collectionView.reloadData()
	}
	
	// MARK: Calculated Properties
	
	var isSearchBarEmpty: Bool {
		return (searchController.searchBar.text?.isEmpty ?? true)
	}
	
	var isSearching: Bool {
		return searchController.isActive && !isSearchBarEmpty
	}
	
	// MARK: Stored Properties
	
	var searchController = UISearchController(searchResultsController: nil)
	
	var filteredItems = [Item]()
	var items = [Item]()
	var category: Category
	
	// MARK: IBOutlets
	
	@IBOutlet var collectionView: UICollectionView!
}

extension ItemsViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let item: Item
		if isSearching {
			item = filteredItems[indexPath.row]
		} else {
			item = items[indexPath.row]
		}
		
		let itemViewController = ItemViewController(item: item)
		itemViewController.item = item
		
		navigationController?.pushViewController(itemViewController, animated: true)
	}
}

extension ItemsViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if isSearching {
			return filteredItems.count
		}
		
		return items.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
		
		let item: Item
		if isSearching {
			item = filteredItems[indexPath.row]
		} else {
			item = items[indexPath.row]
		}
		
		cell.titleLabel.text = item.title
		cell.subtitleLabel.text = item.subtitle
		
		if item.subtitle.isEmpty && UserDefaults.standard.bool(forKey: "ItemShowLatinNameWhenSubtitleIsUnavailable") {
			cell.subtitleLabel.text = item.scientificName
		}
		
		if let urlString = item.images.first?.thumbnailURL, let url = URL(string: urlString) {
			cell.backgroundImageView.setImage(url: url)
		}

		cell.layer.cornerRadius = 8
		cell.clipsToBounds = true
		
		return cell
	}
}

extension ItemsViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.frame.width - 16, height: 240)
	}
}

extension ItemsViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		filterItems(for: searchController.searchBar.text ?? "")
	}
}

extension ItemsViewController: UIViewControllerPreviewingDelegate {
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
		if let indexPath = collectionView.indexPathForItem(at: location) {
			previewingContext.sourceRect = collectionView.bounds
			
			let item: Item
			if isSearching {
				item = filteredItems[indexPath.row]
			} else {
				item = items[indexPath.row]
			}
			
			let itemViewController = ItemViewController(item: item)
			
			return itemViewController
		}
		return nil
	}
	
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
		navigationController?.pushViewController(viewControllerToCommit, animated: true)
	}
}
