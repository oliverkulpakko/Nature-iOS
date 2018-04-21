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
	
	override func reloadData() {
		super.reloadData()
		
		if item == nil {
			done()
			return
		}
		
		title = item.title
		subtitleLabel.text = item.subtitle
		textView.attributedText = item.attributedDescription
		
		ImageCache.fetchImage(from: (item.image?.url ?? ""), id: item.id, completion: { [weak self] image, error in
			DispatchQueue.main.async {
				self?.backgroundImageView.image = image
				self?.imageView.image = image
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
	
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var subtitleLabel: UILabel!
    
    @IBOutlet var textViewContainerView: UIView!
    @IBOutlet var textView: UITextView!
    
}
