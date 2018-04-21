//
//  BaseViewController.swift
//  Nature
//
//  Created by Oliver Kulpakko on 18/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

	// MARK: View Lifecycle

	override func viewDidLoad() {
		Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
		super.viewDidLoad()
		
		UserDefaults.standard.addObserver(self, forKeyPath: "UseDarkTheme", options: .new, context: nil)
		
		setupViews()
		reloadData()
		setInterfaceStrings()
		
		viewHasBeenLoaded = true
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		updateTheme()
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
	func setupViews() {}

	/// Set colors and styles for all UI elements.
	/// Might be called many times during the view's lifecycle, if theme is changed.
	/// Must call super.updateTheme() at some point if overriding.
    /// Navigation controller and tab bars are automatically handled.
	func updateTheme() {
		navigationController?.navigationBar.barStyle = ThemeHelper.currentTheme.barStyle
		navigationController?.toolbar.barStyle = ThemeHelper.currentTheme.barStyle
	}
    
    /// Reload all view displayed on the view.
    /// Must call super.reloadData() at some point if overriding.
    func reloadData() {}

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

	func showError(_ error: Error?, actions: [UIAlertAction] = [], showDimissButton: Bool = true) {
		guard let error = error else {
			return
		}

		print(error)

		var errorText = error.localizedDescription

		#if DEBUG
		errorText = (error as NSError).description
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
			alert.addAction(UIAlertAction(title: "alert.button.ok".localized, style: .cancel, handler: nil))
		}

		DispatchQueue.main.async {
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	// MARK: Private Variables
	
	var viewHasBeenLoaded = false

}
