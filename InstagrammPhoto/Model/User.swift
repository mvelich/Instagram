//
//  User.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 5.12.20.
//  Copyright © 2020 Maksim Velich. All rights reserved.
//

import UIKit

struct User {
    
    var userName: String?
    var profileImage: URL?
    var userStatus: String?
    var followers: String?
    var following: String?
    var photos: [UserPhoto]?
}
