//
//  CategoriesViewController.swift
//  Nature
//
//  Created by Oliver Kulpakko on 18/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import UIKit

class CategoriesViewController: BaseViewController {

	// MARK: View Lifecycle
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if UserDefaults.standard.bool(forKey: "ForceRefreshData") {
			reloadData()
		}
	}
    
    // MARK: BaseViewController
    
    override func setInterfaceStrings() {
        super.setInterfaceStrings()
        
        title = "categories.title".localized
    }
    
    override func setupViews() {
        super.setupViews()
		
		registerForPreviewing(with: self, sourceView: tableView)
		
        tableView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: "CategoryCell")
		
		if #available(iOS 10.0, *) {
			tableView.refreshControl = refreshControl
		} else {
			tableView.addSubview(refreshControl)
		}
		
		let settingsButton = UIBarButtonItem(image: UIImage(named: "categories.button.settings"), style: .plain, target: self, action: #selector(toSettings))
		navigationItem.leftBarButtonItem = settingsButton
    }
	
	override func updateTheme() {
		super.updateTheme()
		
		view.backgroundColor = Theme.current.viewBackgroundColor
		tableView.reloadData()
	}
	
	override func reloadData() {
		super.reloadData()
		
		let country = UserDefaults.standard.string(forKey: "Country") ?? ""
		let forceRefresh = UserDefaults.standard.bool(forKey: "ForceRefreshData")
		
		if forceRefresh {
			refreshControl.beginRefreshing()
		}
		
		DataHelper.fetchCategories(for: country, forceRefresh: forceRefresh, completion: { categories, error in
			guard let categories = categories, error == nil else {
				self.showError(error)
				DispatchQueue.main.async {
					self.refreshControl.endRefreshing()
				}
				return
			}
			
			self.categories = categories
			
			UserDefaults.standard.set(false, forKey: "ForceRefreshData")
			
			DispatchQueue.main.async {
				self.tableView.reloadData()
				self.refreshControl.endRefreshing()
			}
		})
	}
	
	// MARK: Navigation
	
	@objc func toSettings() {
		let settingsViewController = SettingsViewController()
		let navigationController = UINavigationController(rootViewController: settingsViewController)
		settingsViewController.addDoneButton()
		
		present(navigationController, animated: true)
	}
	
	func viewController(for indexPath: IndexPath) -> UIViewController {
		let itemsViewController = ItemsViewController()
		itemsViewController.category = categories[indexPath.row]
		
		return itemsViewController
	}
    
    // MARK: Instance Functions
    
    // MARK: Instance Variables
	
    var categories = [Category]()
    
    // MARK: IBOutlets
    
    @IBOutlet var tableView: UITableView!
}

extension CategoriesViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		navigationController?.pushViewController(viewController(for: indexPath), animated: true)
	}
}

extension CategoriesViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categories.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else {
			return UITableViewCell()
		}
		
		let category = categories[indexPath.row]
		
		cell.categoryNameLabel.text = category.name
		cell.countLabel.text = String(format: "categories.items.%i".localized, category.items.count)
		cell.categoryImageView.image = category.image
		
		cell.backgroundColor = category.color
		cell.tintColor = category.useLightText ? Theme.dark.textColor : Theme.light.textColor
		
		cell.categoryNameLabel.textColor = category.useLightText ? Theme.dark.textColor : Theme.light.textColor
		cell.countLabel.textColor = category.useLightText ? .groupTableViewBackground : .darkGray
		
		return cell
	}
}

extension CategoriesViewController: UIViewControllerPreviewingDelegate {
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
		if let indexPath = tableView.indexPathForRow(at: location) {
			previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
			
			return viewController(for: indexPath)
		}
		return nil
	}
	
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
		navigationController?.pushViewController(viewControllerToCommit, animated: true)
	}
}
