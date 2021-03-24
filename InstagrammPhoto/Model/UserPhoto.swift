//
//  UserPhoto.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 5.12.20.
//  Copyright © 2020 Maksim Velich. All rights reserved.
//

import UIKit

struct UserPhoto {
    
    var image: URL?
    var likes: Int?
    var location: String?
    var description: String?
    var date: Date = Date()
    var uid: String?
}
