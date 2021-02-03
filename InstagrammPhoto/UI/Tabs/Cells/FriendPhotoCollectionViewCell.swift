//
//  FriendPhotoCollectionViewCell.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 31.01.21.
//  Copyright © 2021 Maksim Velich. All rights reserved.
//

import UIKit

class FriendPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var widthCellConstraint: NSLayoutConstraint! {
        didSet {
            widthCellConstraint.constant = (UIScreen.main.bounds.size.width - 4) / 3
        }
    }
    
}
