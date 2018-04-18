//
//  ItemsViewController.swift
//  Nature
//
//  Created by Oliver Kulpakko on 18/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import UIKit

class ItemsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

	//MARK: View Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	// MARK: BaseViewController
	
	override func setInterfaceStrings() {
		super.setInterfaceStrings()
		
		title = category.name
	}
	
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
	}
	
	// MARK: UITableViewDelegate
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	// MARK: UITableViewDataSource
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return category.items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as? ItemCell else {
			return UITableViewCell()
		}
		
		let item = category.items[indexPath.row]
		
		cell.titleLabel.text = item.title
		cell.subtitleLabel.text = item.subtitle
		
		ImageCache.fetchImage(from: item.imageURL, id: item.id, completion: { [weak cell] image, error in
			DispatchQueue.main.async {
				cell?.backgroundImageView.image = image
			}
		})
		
		return cell
	}
	
	// MARK: Instance Functions
	
	// MARK: Instance Variables
	
	var category: Category!
	
	// MARK: IBOutlets
	
	@IBOutlet var tableView: UITableView!
}
