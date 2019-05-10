//
//  ItemCell.swift
//  Nature
//
//  Created by Oliver Kulpakko on 10/05/2019.
//  Copyright © 2019 Oliver Kulpakko. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {
	@IBOutlet var backgroundImageView: UIImageView!
	@IBOutlet var dimmingView: UIView!

	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var subtitleLabel: UILabel!

	override func prepareForReuse() {
		super.prepareForReuse()

		backgroundImageView.cancelImageFetch()
		backgroundImageView.image = nil
	}
}
