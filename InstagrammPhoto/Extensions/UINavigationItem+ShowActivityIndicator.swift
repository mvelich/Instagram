//
//  UIBarButtonItem+ShowActivityIndicator.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 10.02.21.
//  Copyright © 2021 Maksim Velich. All rights reserved.
//

import UIKit

extension UINavigationItem {
    
    func showRightButtonActivityIndicator(completion: @escaping ()->()) {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.sizeToFit()
        activityIndicator.color = .white
        let activityBarButton = UIBarButtonItem(customView: activityIndicator)
        self.setRightBarButton(activityBarButton, animated: true)
        let delay = 3
        activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay), execute: {
            activityIndicator.stopAnimating()
            completion()
        })
    }
}
