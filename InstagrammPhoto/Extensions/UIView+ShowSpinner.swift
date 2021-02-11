//
//  UIView+ShowSpinner.swift
//  InstagrammPhoto
//
//  Created by Alex Rybchinsky on 19.01.21.
//  Copyright © 2021 Maksim Velich. All rights reserved.
//

import UIKit

extension UIView {
    
    func showSpinner() {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.backgroundColor = UIColor(white: 0, alpha: 0.8)
        spinner.color = .white
        self.addSubview(spinner)
        spinner.frame = self.frame
        let delay = 4
        spinner.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            spinner.stopAnimating()
        }
    }
}
