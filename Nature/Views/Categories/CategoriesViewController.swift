//
//  CategoriesViewController.swift
//  Nature
//
//  Created by Oliver Kulpakko on 18/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import UIKit

class CategoriesViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: BaseViewController
    
    override func setInterfaceStrings() {
        super.setInterfaceStrings()
        
        title = "categories.title".localized
    }
    
    override func setupViews() {
        super.setupViews()
        
        tableView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: "CategoryCell")
		
		let settingsButton = UIBarButtonItem(title: "categories.button.settings".localized, style: .plain, target: self, action: #selector(toSettings))
		navigationItem.leftBarButtonItem = settingsButton
    }
	
	override func updateTheme() {
		super.updateTheme()
		
		view.backgroundColor = Theme.current.tableViewBackgroundColor
		tableView.reloadData()
	}
	
	override func reloadData() {
		super.reloadData()
		
		let country = "" // TODO: Fetch for the current country, but for now download for every country.
		let forceRefresh = UserDefaults.standard.bool(forKey: "ForceRefreshData")
		
		DataHelper.fetchCategories(for: country, forceRefresh: forceRefresh, completion: { categories, error in
			guard let categories = categories, error == nil else {
				self.showError(error)
				return
			}
			
			self.categories = categories
			
			
			UserDefaults.standard.set(false, forKey: "ForceRefreshData")
			
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		})
	}
    
    // MARK: UITableViewDelegate
	
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
		
		let itemsViewController = ItemsViewController()
		itemsViewController.category = categories[indexPath.row]
		
		navigationController?.pushViewController(itemsViewController, animated: true)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else {
			return UITableViewCell()
		}
		
        let category = categories[indexPath.row]
		
        cell.categoryNameLabel.text = category.name
		cell.categoryNameLabel.textColor = category.useLightText ? .white : .darkText
		
		cell.countLabel.text = String(format: "categories.items.%i".localized, category.items.count)
		
		cell.categoryImageView.image = category.image
		
		cell.backgroundColor = category.color
        cell.tintColor = category.useLightText ? .white : .darkText
		
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
    
    var categories = [Category]()
    
    // MARK: IBOutlets
    
    @IBOutlet var tableView: UITableView!
}
