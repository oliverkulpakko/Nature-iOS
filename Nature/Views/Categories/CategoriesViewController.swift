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
    }
	
	override func reloadData() {
		super.reloadData()
		
		DataHelper.fetchCategories(completion: { categories, error in
			guard let categories = categories, error == nil else {
				self.showError(error)
				return
			}
			
			self.categories = categories
			
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
    
    // MARK: Instance Functions
    
    // MARK: Instance Variables
    
    var categories = [Category]()
    
    // MARK: IBOutlets
    
    @IBOutlet var tableView: UITableView!
}
