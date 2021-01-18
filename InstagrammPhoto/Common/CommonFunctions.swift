//
//  CommonFunctions.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 16.01.21.
//  Copyright © 2021 Maksim Velich. All rights reserved.
//

import UIKit

class CommonFunctions {
    
    static func showSpinner(_ view: UIView) {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.backgroundColor = UIColor(white: 0, alpha: 0.8)
        spinner.color = .red
        view.addSubview(spinner)
        spinner.frame = view.frame
        let delay = 4
        spinner.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            spinner.stopAnimating()
        }
    }
}
