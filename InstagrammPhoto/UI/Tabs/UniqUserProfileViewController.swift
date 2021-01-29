//
//  IndividualUserProfileViewController.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 26.01.21.
//  Copyright © 2021 Maksim Velich. All rights reserved.
//

import UIKit
import Kingfisher

class UniqUserProfileViewController: UIViewController {
    
    var userName: String?
    var userUID: String?
    var profileImage: URL?
    
    @IBOutlet weak var uniqUserProfileImage: UIImageView!
    @IBOutlet weak var followUserButton: UIButton!
    @IBOutlet weak var messageButton: UIButton! {
        didSet {
            messageButton.addGreyBorder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = userName
        uniqUserProfileImage.setRounded()
        uniqUserProfileImage.kf.setImage(with: profileImage)
    }
    
    func setInitialUserData() { }
    
    func updateProfilePhotos() { }
}

extension UniqUserProfileViewController {
    
}
