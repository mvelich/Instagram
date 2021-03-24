//
//  UIButton+AddGreyBorder.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 27.01.21.
//  Copyright © 2021 Maksim Velich. All rights reserved.
//

import UIKit

extension UIButton {
    
    func addGreyBorder() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
    }
}

