//
//  UIButton+SetRounded.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 11.03.21.
//  Copyright © 2021 Maksim Velich. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setRounded() {
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        self.clipsToBounds = true
    }
}

