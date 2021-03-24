//
//  FriendSearchTableViewCell.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 24.01.21.
//  Copyright © 2021 Maksim Velich. All rights reserved.
//

import UIKit

class FriendSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.setRounded()
    }
}
