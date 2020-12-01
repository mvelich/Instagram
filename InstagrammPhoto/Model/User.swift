//
//  User.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 11/15/20.
//  Copyright © 2020 Maksim Velich. All rights reserved.
//

import RealmSwift

@objcMembers
class User: Object {
    dynamic var name: String = ""
    dynamic var password: String = ""
    dynamic var nickname: String = ""
    dynamic var userStatus: String = ""
    dynamic var followers = List<User>()
    dynamic var following = List<User>()
    dynamic var photos = List<Photo>()
}
