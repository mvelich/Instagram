//
//  UIImageView+SetRounded.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 1.12.20.
//  Copyright © 2020 Maksim Velich. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setRounded() {
        self.layer.cornerRadius = (self.frame.width / 2)
        self.layer.masksToBounds = true
    }
}
