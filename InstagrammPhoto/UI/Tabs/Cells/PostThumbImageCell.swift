//
//  PostThumbImageCell.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 11/24/20.
//  Copyright © 2020 Maksim Velich. All rights reserved.
//

import UIKit

class PostThumbImageCell: UICollectionViewCell {
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var widthCellConstraint: NSLayoutConstraint! {
        didSet {
            widthCellConstraint.constant = (UIScreen.main.bounds.size.width - 4) / 3
        }
    }
}
