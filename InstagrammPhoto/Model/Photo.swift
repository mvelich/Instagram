//
//  Photo.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 11/19/20.
//  Copyright © 2020 Maksim Velich. All rights reserved.
//

import RealmSwift

@objcMembers
class Photo: Object {
    dynamic var id = ""
    dynamic var displayUrl: String = ""
    dynamic var likeNumber: Int = 0
    dynamic var locationName: String = ""
    dynamic var photoDescription: String = ""
    // need to add index for photo to understand displaying sequence
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
