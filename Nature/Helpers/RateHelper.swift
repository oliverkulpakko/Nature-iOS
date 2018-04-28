//
//  RateHelper.swift
//  Nature
//
//  Created by Oliver Kulpakko on 24.4.2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import UIKit
import StoreKit

class RateHelper {
	class func openRate() {
		let appID = "1314524822"

		openAppStore(appID: appID)
	}

	class func showRatingPrompt() {
		if #available(iOS 10.3, *) {
			SKStoreReviewController.requestReview()
			Analytics.log(action: "AskForReview")
		} else {
			Analytics.log(action: "AskForReview", error: "TooOldVersion", data1: "", data2: "")
		}
	}

	private class func openAppStore(appID: String) {
		guard let url = URL(string : "itms-apps://itunes.apple.com/app/id" + appID) else {
			return
		}

		UIApplication.shared.openURL(url)
	}
}
