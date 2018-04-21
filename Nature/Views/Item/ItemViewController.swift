//
//  ItemViewController.swift
//  Nature
//
//  Created by Oliver Kulpakko on 18/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import UIKit
import Imaginary
import Lightbox

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
		
		if item.subtitle.isEmpty && UserDefaults.standard.bool(forKey: "ItemShowLatinNameWhenSubtitleIsUnavailable") {
			subtitleLabel.text = item.latinName
		}
		
		textView.attributedText = item.attributedDescription
		
		if let url = URL(string: item.image?.url ?? "") {
			backgroundImageView.setImage(url: url)
			imageView.setImage(url: url)
		}
		
		let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(showImageViewer))
		tapRecognizer.numberOfTapsRequired = 1
		imageView.addGestureRecognizer(tapRecognizer)
	}
	
	// MARK: Instance Functions
	
	@objc func showImageViewer() {
		guard let image = imageView.image else {
			return
		}
		
		let images = [
			LightboxImage(
				image: image,
				text: item.image?.description ?? ""
			)
		]
		
		let controller = LightboxController(images: images)
		controller.dynamicBackground = true
		
		present(controller, animated: true, completion: nil)
	}
	
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
