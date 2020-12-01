//
//  TabBarController.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 11/17/20.
//  Copyright © 2020 Maksim Velich. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isTranslucent = false
        self.tabBar.barTintColor = UIColor.black
        self.tabBar.items?[0].badgeColor = UIColor.white
        self.tabBar.items?[1].badgeColor = UIColor.white
    }
}
