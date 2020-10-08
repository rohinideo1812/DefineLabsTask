//
//  UIView+Extension.swift
//  Pay Invoice Buyer
//
//  Created by Rohini Deo on 27/07/20.
//  Copyright © 2020 Taxgenie. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func dropShadow() {
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize.zero
    }
}
