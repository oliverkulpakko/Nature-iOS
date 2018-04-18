//
//  ItemViewController.swift
//  Nature
//
//  Created by Oliver Kulpakko on 18/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import UIKit

class ItemViewController: BaseViewController {
	
	//MARK: View Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	// MARK: BaseViewController
	
	override func setInterfaceStrings() {
		super.setInterfaceStrings()
		
		title = item.title
	}
	
	override func updateTheme() {
		super.updateTheme()
	}
	
	override func reloadData() {
		super.reloadData()
		
		if item == nil {
			done()
			return
		}
		
		ImageCache.fetchImage(from: item.imageURL, id: item.id, completion: { [weak self] image, error in
			DispatchQueue.main.async {
				self?.backgroundImageView.image = image
			}
		})
	}
	
	// MARK: Instance Functions
	
	// MARK: Instance Variables
	
	var item: Item!
	
	// MARK: IBOutlets
	
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var backgroundVisualEffectView: UIVisualEffectView!
    
    @IBOutlet var scrollView: UIScrollView!
}
