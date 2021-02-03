//
//  Constants.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 19.01.21.
//  Copyright © 2021 Maksim Velich. All rights reserved.
//

struct Constants {
    
    enum Segue: String {
        case signUpSegueIdentifier = "userRegistration"
        case fullScreenSegueIdentifier = "FullScreenPhotoViewController"
        case editProfileSegueIdentifier = "EditProfileViewController"
        case addPhotoSegueIdentifier = "AddPhotoViewController"
        case uniqUserProfileIdentifier = "UniqUserProfileViewController"
    }
    
    enum Cell: String {
        case reusableTableCellIdentifier = "TapeTableViewCell"
        case reusableCollectionCellIdentifier = "PostThumbImageCell"
        case reusableTableFriendSearchCellIdentifier = "FriendSearchTableViewCell"
        case reusableCollectionFriendPhotoCellIdentifier = "FriendPhotoImageCell"
    }
}
