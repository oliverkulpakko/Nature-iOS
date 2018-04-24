//
//  SwitchCell.swift
//  Nature
//
//  Created by Oliver Kulpakko on 21/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import UIKit

class SwitchCell: UITableViewCell {
	
	var didToggle: (() -> Void)?

	@IBOutlet var iconImageView: UIImageView!
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var `switch`: UISwitch!
	
	@IBAction func didSwitch(_ sender: UISwitch) {
		didToggle?()
	}
	
}
