//
//  databaseLogicHandler.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 11/15/20.
//  Copyright © 2020 Maksim Velich. All rights reserved.
//

import Firebase

class DatabaseLogicHandler {
    let db = Firestore.firestore()
    let currentUserUid = Auth.auth().currentUser?.uid    
    
    func getUserAllPhotos() {
        db.collection("users").document(currentUserUid!).collection("photos").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print(document.data())
                }
            }
        }
    }
    
    func addPhotoToUser(_ photoUrl: String) {
        db.collection("users").document(currentUserUid!).collection("photos").document().setData([
            "url": "\(photoUrl)",
            "likeNumber": "0",
            "locationName": "default",
            "photo_description": "default"
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}

