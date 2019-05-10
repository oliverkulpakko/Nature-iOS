//
//  ItemsFlowLayout.swift
//  Nature
//
//  Created by Oliver Kulpakko on 10/05/2019.
//  Copyright © 2019 Oliver Kulpakko. All rights reserved.
//

import UIKit

class ItemsFlowLayout: UICollectionViewFlowLayout {
	override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		return true
	}
}
