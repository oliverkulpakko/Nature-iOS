//
//  BaseViewController.swift
//  Nature
//
//  Created by Oliver Kulpakko on 18/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

	// MARK: Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		
		UserDefaults.standard.addObserver(self, forKeyPath: "UseDarkTheme", options: .new, context: nil)
		
		setupViews()
		reloadData()
		setInterfaceStrings()
		
		saveAnalytics()
		
		if Analytics.count(for: "OpenView") > 10 && Analytics.count(for: "AskForReview") == 0 {
			RateHelper.showRatingPrompt()
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		updateTheme()
	}

	// MARK: Initializers

	init() {
		super.init(nibName: String(describing: type(of: self)), bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	deinit {
		UserDefaults.standard.removeObserver(self, forKeyPath: "UseDarkTheme")
	}
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == "UseDarkTheme" {
			updateTheme()
		}
	}

	// MARK: Setup Views

	/// Set all interface strings to localized versions.
	/// Must call super.setInterfaceStrings() at some point if overriding.
	func setInterfaceStrings() {}

	/// Set all view properties.
	/// Must call super.setupViews() at some point if overriding.
	func setupViews() {
		refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
	}

	/// Set colors and styles for all UI elements.
	/// Might be called many times during the view's lifecycle, if theme is changed.
	/// Must call super.updateTheme() at some point if overriding.
    /// Navigation controller and tab bars are automatically handled.
	func updateTheme() {
		navigationController?.navigationBar.barStyle = Theme.current.barStyle
		navigationController?.toolbar.barStyle = Theme.current.barStyle

		isThemeSet = true
	}
    
    /// Reload all view displayed on the view.
    /// Must call super.reloadData() at some point if overriding.
    @objc func reloadData() {}
	
	/// Save analytics data.
	/// Override if something else needs to be sent. No need to call super whn
	func saveAnalytics() {
		Analytics.log(action: "OpenView", error: "", data1: String(describing: type(of: self)), data2: "")
	}

	// MARK: Navigation

	func addDoneButton() {
		let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))

		if navigationItem.rightBarButtonItems?.isEmpty ?? true {
			navigationItem.rightBarButtonItem = doneButton
		} else {
			navigationItem.rightBarButtonItems?.append(doneButton)
		}
	}

	@objc func done() {
		dismiss(animated: true, completion: nil)
	}

	override func present(_ viewControllerToPresent: UIViewController,
						  animated flag: Bool,
						  completion: (() -> Void)? = nil) {
		if viewControllerToPresent is UINavigationController {
			if #available(iOS 11.0, *) {
				(viewControllerToPresent as? UINavigationController)?.navigationBar.prefersLargeTitles = true
			}
		}
		super.present(viewControllerToPresent, animated: flag, completion: completion)
	}

	// MARK: UIAlertController

	func presentError(_ error: Error?, actions: [UIAlertAction] = [], showDimissButton: Bool = true) {
		guard let error = error else {
			return
		}

		#if DEBUG
		let errorText = (error as NSError).description
		#else
		let errorText = error.localizedDescription
		#endif

		showAlert(title: "alert.title.error".localized, message: errorText,
				  actions: actions, addDimissButton: showDimissButton)
	}

	func showAlert(title: String, message: String? = nil, actions: [UIAlertAction] = [], addDimissButton: Bool = true) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

		for action in actions {
			alert.addAction(action)
		}

		if addDimissButton {
			alert.addOKAction()
		}

		DispatchQueue.main.async {
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	// MARK: Private Variables
	
	var isThemeSet = false
	var refreshControl = UIRefreshControl()
}
