//
//  String.swift
//  Nature
//
//  Created by Oliver Kulpakko on 18/04/2018.
//  Copyright © 2018 Oliver Kulpakko. All rights reserved.
//

import Foundation

extension String {
    /// Returns a localized version of self
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
