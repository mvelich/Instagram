//
//  FullScreenPhotoViewController.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 29.12.20.
//  Copyright © 2020 Maksim Velich. All rights reserved.
//

import UIKit

class FullScreenPhotoViewController: UIViewController {
    
    var fullScreenImage: UIImage?
    
    @IBOutlet weak var fullScreenImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullScreenImageView.image = fullScreenImage
    }
}
