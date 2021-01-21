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
import Kingfisher

class ProfileViewController: UIViewController {
    
    private var imagesArray = [URL]()
    
    @IBOutlet weak var photoGridCollectionView: UICollectionView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var userStatus: UILabel!
    @IBOutlet weak var postNumberLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoGridCollectionView.dataSource = self
        photoGridCollectionView.delegate = self
        profileImage.setRounded()
        setInitialUserData()
        updateProfilePhotos()
        self.view.showSpinner()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.editProfileSegueIdentifier.rawValue {
            if let editProfileVC = segue.destination as? EditProfileViewController {
                if let status = userStatus.text {
                    editProfileVC.currentProfileStatus = status
                }
            }
        }
        
        if segue.identifier == Constants.Segue.fullScreenSegueIdentifier.rawValue {
            if let fullScreenVC = segue.destination as? FullScreenPhotoViewController {
                if let cell = sender as? UICollectionViewCell,
                   let indexPath = self.photoGridCollectionView.indexPath(for: cell){
                    let image = ImageCache.default.retrieveImageInMemoryCache(forKey: imagesArray[indexPath.item].absoluteString)
                    fullScreenVC.fullScreenImage = image
                }
            }
        }
    }
    
    @IBAction func editProfilePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: Constants.Segue.editProfileSegueIdentifier.rawValue, sender: self)
    }
    
    @IBAction func addPhotoPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: Constants.Segue.addPhotoSegueIdentifier.rawValue, sender: self)
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let signInViewController = storyboard.instantiateViewController(identifier: "SignInViewController")
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(signInViewController)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) { }
    
    func setInitialUserData() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(currentUserUid).getDocument() { (document, err) in
            if let err = err {
                print("Error getting document: \(err)")
            } else {
                DispatchQueue.main.async {
                    self.userStatus.text = (document?.get("user_status") as! String)
                    self.profileName.text = (document?.get("nick_name") as! String)
                    let url = URL(string: document?.get("profile_image") as! String)
                    self.profileImage.kf.setImage(with: url)
                }
            }
        }
    }
    
    func updateProfilePhotos() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(currentUserUid).collection("photos").order(by: "date", descending: true).addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting document: \(err)")
            } else {
                self.imagesArray = (querySnapshot?.documents.compactMap { URL(string: $0.get("image") as! String) })!
                
                DispatchQueue.main.async {
                    self.postNumberLabel.text = String(self.imagesArray.count)
                    self.photoGridCollectionView.reloadData()
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cell.reusableCollectionCellIdentifier.rawValue,
                                                      for: indexPath) as! PostThumbImageCell
        let url = imagesArray[indexPath.row]
        cell.photoImage.kf.setImage(with: url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.Segue.fullScreenSegueIdentifier.rawValue, sender: self)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}

