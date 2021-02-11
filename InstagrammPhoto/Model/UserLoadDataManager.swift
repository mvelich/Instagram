//
//  databaseLogicHandler.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 11/15/20.
//  Copyright © 2020 Maksim Velich. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class UserLoadDataManager {
    
    var user = User()
    
    func fetchUserAccountData() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(currentUserUid).getDocument() { (document, err) in
            if let err = err {
                print("Error getting document: \(err)")
            } else {
                self.user.userName = (document?.get("nick_name") as! String)
                self.user.profileImage = URL(string: document?.get("profile_image") as! String)
                self.user.userStatus = (document?.get("user_status") as! String)
            }
        }
    }
    
    func getUserPhotos() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        var userPhotos = [UserPhoto()]
        Firestore.firestore().collection("users").document(currentUserUid).collection("photos").getDocuments { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting document: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    var photo = UserPhoto()
                    photo.image = URL(string: (document.get("image") as? String)!)
                    photo.likes = (document.get("likes") as? Int)
                    photo.location = (document.get("location") as? String)
                    photo.description = (document.get("description") as? String)
                    photo.date = (document.get("date") as! Date)
                    userPhotos.append(photo)
                }
                self.user.photos = userPhotos
            }
        }
    }
}

