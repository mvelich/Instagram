//
//  ProfileViewController.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 11/17/20.
//  Copyright © 2020 Maksim Velich. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class ProfileViewController: UIViewController {
    let db = Firestore.firestore()
    let currentUserUid = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var userStatus: UILabel!
    @IBOutlet weak var profilePhotosView: UICollectionView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.setRounded()
        setInitialUserData()
    }
    
    @IBAction func editProfilePressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                guard let editProfileViewController = storyboard.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController else { return }
        
                present(editProfileViewController, animated: true, completion: nil)
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signInViewController = storyboard.instantiateViewController(identifier: "SignInViewController")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(signInViewController)
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
        
    }
}

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostThumbImageCell", for: indexPath) as! PostThumbImageCell
        cell.backgroundColor = UIColor.red
        // cell.photoImage.image
        return cell
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 3
        let spacing: CGFloat = 1.5
        let totalHorizontalSpacing = (columns - 1) * spacing
        
        let itemWidth = (UIScreen.main.bounds.width - totalHorizontalSpacing) / columns
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
}

extension ProfileViewController {
    func setInitialUserData() {
        db.collection("users").document(currentUserUid!).getDocument() { (document, err) in
            if let err = err {
                print("Error getting document: \(err)")
            } else {
                self.userStatus.text = (document?.get("user_status") as! String)
                self.profileName.text = (document?.get("nick_name") as! String)
                let url = URL(string: document?.get("profile_image") as! String)
                if let data = try? Data(contentsOf: url!) {
                    self.profileImage.image = UIImage(data: data)
                    }
            }
        }
    }
}
