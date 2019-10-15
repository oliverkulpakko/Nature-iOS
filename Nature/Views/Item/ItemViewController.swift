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
	
	//MARK: Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		navigationController?.setToolbarHidden(true, animated: true)
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

		view.backgroundColor = Theme.current.viewBackgroundColor

		if UserDefaults.standard.bool(forKey: "UseSimpleItemView") {
			backgroundVisualEffectView.isHidden = true
			textView.textColor = Theme.current.textColor
			subtitleLabel.textColor = Theme.current.textColor
		} else {
			backgroundVisualEffectView.isHidden = false
			textView.textColor = .white
			subtitleLabel.textColor = .white
		}
	}
	
	override func reloadData() {
		super.reloadData()
		
		title = item.title
		subtitleLabel.text = item.subtitle
		
		if item.subtitle.isEmpty && UserDefaults.standard.bool(forKey: "ItemShowLatinNameWhenSubtitleIsUnavailable") {
			subtitleLabel.text = item.scientificName
		}
		
		textView.attributedText = item.attributedDescription
		
		if let image = item.images.first, let url = URL(string: image.url), let thumbnailUrl = URL(string: image.thumbnailURL) {
			if !UserDefaults.standard.bool(forKey: "UseSimpleItemView") {
				backgroundImageView.setImage(url: thumbnailUrl)
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
		let images: [LightboxImage] = item.images.compactMap {
			guard let url = URL(string: $0.fullSizeURL) else {
				return nil
			}

			return LightboxImage(imageURL: url, text: $0.attribution?.value ?? "", videoURL: nil)
		}
		
		let controller = LightboxController(images: images)
		controller.dynamicBackground = true
		controller.modalPresentationStyle = .fullScreen
		
		present(controller, animated: true, completion: nil)
	}
	
	@objc func showCopyright() {
		let alert = UIAlertController(title: "item.alert.copyright.title".localized, message: nil, preferredStyle: .alert)
		
		if let url = URL(string: item.detailURL) {
			let action = UIAlertAction(title: "item.alert.copyright.button.article".localized, style: .default, handler: { action in
				self.openURL(url, modally: true)
			})
			alert.addAction(action)
		}
		
		if let urlString = item.images.first?.attribution?.url, let url = URL(string: urlString) {
			let action = UIAlertAction(title: "item.alert.copyright.button.image".localized, style: .default, handler: { action in
				self.openURL(url, modally: true)
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
	@IBOutlet var backgroundVisualEffectView: UIVisualEffectView!

	@IBOutlet var scrollView: UIScrollView!
	
	@IBOutlet var imageView: UIImageView!
	@IBOutlet var subtitleLabel: UILabel!

	@IBOutlet var textViewContainerView: UIView!
	@IBOutlet var textView: UITextView!

}
