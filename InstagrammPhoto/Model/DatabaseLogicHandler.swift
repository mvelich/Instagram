//
//  databaseLogicHandler.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 11/15/20.
//  Copyright © 2020 Maksim Velich. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseLogicHandler {
    
    let realm = try! Realm()
    var currentUserAccountNickName = ""
    var currentUserName = ""
    
    func addNewUser(user: User) {
        let allUsers = getAllUser()
        var isUserExist = false
        
        for userRealm in allUsers {
            if userRealm.name == user.name {
                isUserExist = true
            } else {
                isUserExist = false
            }
        }
        
        if isUserExist {
            print("user already exist")
        } else {
            try! realm.write{
                realm.add(user)
            }
        }
    }
    
    func getAllUser() -> [User] {
        let allUsers = realm.objects(User.self)
        return Array(allUsers)
    }
    
    func getCurrentUser(userName: String) -> User? {
        let usersArray = getAllUser()
        for user in usersArray {
            if user.name == userName {
                return user
            }
        }
        return nil
    }
    
    func accessToLogin(userName: String, userPassword: String) -> Bool{
        
        let allUsers = getAllUser()
        var accessToLogin = false
        
        for userRealm in allUsers {
            if userRealm.name == userName && userRealm.password == userPassword {
                accessToLogin = true
                currentUserName = userRealm.name
                currentUserAccountNickName = userRealm.nickname
            } else {
                accessToLogin = false
            }
        }
        return accessToLogin
    }
}

