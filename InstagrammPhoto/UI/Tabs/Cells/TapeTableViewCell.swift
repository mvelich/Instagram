//
//  TapeTableViewCell.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 11/27/20.
//  Copyright © 2020 Maksim Velich. All rights reserved.
//

import UIKit

class TapeTableViewCell: UITableViewCell {
    @IBOutlet weak var tapeImgae: UIImageView!
    @IBOutlet weak var friendNameTop: UILabel!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var friendNameButtom: UILabel!
    @IBOutlet weak var imageDescription: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
