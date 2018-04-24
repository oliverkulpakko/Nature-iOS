//
//  ItemCell.swift
//  Nature
//
//  Created by Oliver Kulpakko on 18/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import UIKit
import Imaginary

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet var dimmingView: UIView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		backgroundImageView.cancelImageFetch()
		backgroundImageView.image = nil
	}
}
