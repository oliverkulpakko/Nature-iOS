//
//  ItemViewController.swift
//  Nature
//
//  Created by Oliver Kulpakko on 18/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import UIKit
import Imaginary
//import Lightbox
import SafariServices

class ItemViewController: BaseViewController {
	
	//MARK: Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	// MARK: BaseViewController
	
	override func setupViews() {
		super.setupViews()
		
		let bookmarksButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showMap))
		let copyrightButton = UIBarButtonItem(image: UIImage(named: "item.button.copyright"), style: .plain, target: self, action: #selector(showCopyright))
		
		navigationItem.rightBarButtonItems = [copyrightButton, bookmarksButton]
	}

	override func updateTheme() {
		super.updateTheme()

		if UserDefaults.standard.bool(forKey: "UseSimpleItemView") {
			view.backgroundColor = Theme.current.viewBackgroundColor
			backgroundVisualEffectView.isHidden = true
			imageDarkenerView.isHidden = true
			textView.textColor = Theme.current.textColor
			subtitleLabel.textColor = Theme.current.textColor
		} else {
			textView.textColor = .white
			subtitleLabel.textColor = .white
		}
	}
	
	override func reloadData() {
		super.reloadData()
		
		title = item.title
		subtitleLabel.text = item.subtitle
		
		if item.subtitle.isEmpty && UserDefaults.standard.bool(forKey: "ItemShowLatinNameWhenSubtitleIsUnavailable") {
			subtitleLabel.text = item.latinName
		}
		
		textView.attributedText = item.attributedDescription
		
		if let url = URL(string: item.image?.url ?? "") {
			if !UserDefaults.standard.bool(forKey: "UseSimpleItemView") {
				backgroundImageView.setImage(url: url)
			}

			imageView.setImage(url: url)
		}
		
		let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(showImageViewer))
		tapRecognizer.numberOfTapsRequired = 1
		imageView.addGestureRecognizer(tapRecognizer)
	}
	
	override func saveAnalytics() {
		analytics.logAction("OpenView", data1: String(describing: type(of: self)), data2: item.id, error: nil)
	}

	// MARK: Initializer

	init(item: Item) {
		self.item = item
		super.init()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: Instance Methods
	
	@objc func showImageViewer() {
		/*guard let image = imageView.image else {
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
		
		present(controller, animated: true, completion: nil)*/
	}
	
	@objc func showCopyright() {
		let alert = UIAlertController(title: "item.alert.copyright.title".localized, message: nil, preferredStyle: .alert)
		
		if let url = URL(string: item.detailURL) {
			let action = UIAlertAction(title: "item.alert.copyright.button.article".localized, style: .default, handler: { action in
				let safariViewController = SFSafariViewController(url: url)
				
				self.present(safariViewController, animated: true)
			})
			alert.addAction(action)
		}
		
		if let url = URL(string: item.image?.source ?? "") {
			let action = UIAlertAction(title: "item.alert.copyright.button.image".localized, style: .default, handler: { action in
				let safariViewController = SFSafariViewController(url: url)
				
				self.present(safariViewController, animated: true)
			})
			alert.addAction(action)
		}
		
		alert.addCancelAction()
		
		present(alert, animated: true)
	}
	
	@objc func showMap() {
		let mapViewController = MapViewController(item: item)
		mapViewController.addDoneButton()
		
		let navigationController = UINavigationController(rootViewController: mapViewController)
		
		present(navigationController, animated: true)
	}
	
	// MARK: Stored Properties
	
	var item: Item
	
	// MARK: IBOutlets
	
    @IBOutlet var backgroundImageView: UIImageView!
	@IBOutlet var imageDarkenerView: UIView!
    @IBOutlet var backgroundVisualEffectView: UIVisualEffectView!
    
    @IBOutlet var scrollView: UIScrollView!
	
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var subtitleLabel: UILabel!
    
    @IBOutlet var textViewContainerView: UIView!
    @IBOutlet var textView: UITextView!
    
}
