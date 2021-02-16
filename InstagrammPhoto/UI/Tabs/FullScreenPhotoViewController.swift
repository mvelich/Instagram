//
//  FullScreenPhotoViewController.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 29.12.20.
//  Copyright © 2020 Maksim Velich. All rights reserved.
//

import UIKit
import Firebase

class FullScreenPhotoViewController: UIViewController {
    
    var fullScreenImage: UIImage?
    var imageUID: String?
    
    @IBOutlet weak var fullScreenImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullScreenImageView.image = fullScreenImage
    }
    
    @IBAction func closeFullScreenPhotoPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deletePhotoPressed() {
        showDeletionAlert()
    }
    
    func showDeletionAlert() {
        let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { _ in
            self.deletePhoto()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func deletePhoto() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        guard let imageUID = imageUID else { return }
        Storage.storage().reference().child("\(imageUID)").delete { error in
            if let error = error {
                print("Error deleting document: \(error.localizedDescription)")
            } else {
                Firestore.firestore().collection("users").document(currentUserUid).collection("photos").document(imageUID).delete{ err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
}
