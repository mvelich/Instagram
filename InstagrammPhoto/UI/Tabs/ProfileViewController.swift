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
    
    private var photoCellArray = [UserPhoto]()
    
    @IBOutlet weak var photoGridCollectionView: UICollectionView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var userStatus: UILabel!
    @IBOutlet weak var postNumberLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton! {
        didSet {
            editProfileButton.addGreyBorder()
        }
    }
    @IBOutlet weak var addNewPhotoButton: UIButton! {
        didSet {
            addNewPhotoButton.addGreyBorder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoGridCollectionView.dataSource = self
        photoGridCollectionView.delegate = self
        profileImage.setRounded()
        setInitialUserData()
        updateProfilePhotos()
        photoGridCollectionView.collectionViewLayout = LeftAlignmentFlowLayout(minimumInteritemSpacing: 2, minimumLineSpacing: 2)
        self.view.showSpinner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func editProfilePressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let editProfileVC = storyboard.instantiateViewController(identifier: Constants.Segue.editProfileSegueIdentifier.rawValue) as? EditProfileViewController else { return }
        editProfileVC.currentProfileStatus = userStatus.text
        editProfileVC.currentProfileImage = profileImage.image
        editProfileVC.callback = { [weak self] in
            self?.setInitialUserData()
        }
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    @IBAction func addPhotoPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let addPhotoVC = storyboard.instantiateViewController(identifier: Constants.Segue.addPhotoSegueIdentifier.rawValue) as? AddPhotoViewController else { return }
        navigationController?.pushViewController(addPhotoVC, animated: true)
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
                self.photoCellArray.removeAll()
                guard let dataSnapShot = querySnapshot?.documents else { return }
                for document in dataSnapShot {
                    var photo = UserPhoto()
                    photo.image = URL(string: document.get("image") as! String)
                    photo.likes = (document.get("likes") as? Int)
                    photo.location = (document.get("location") as? String)
                    photo.description = (document.get("description") as? String)
                    let timestamp = document.get("date") as! Timestamp
                    photo.date = timestamp.dateValue()
                    photo.uid = (document.get("uid") as? String)
                    self.photoCellArray.append(photo)
                }
                
                DispatchQueue.main.async {
                    self.postNumberLabel.text = String(self.photoCellArray.count)
                    self.photoGridCollectionView.reloadData()
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoCellArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cell.reusableCollectionCellIdentifier.rawValue,
                                                      for: indexPath) as! ProfileCollectionViewCell
        let url = photoCellArray[indexPath.row].image
        cell.photoImage.kf.setImage(with: url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let fullScreenPhotoVC = storyboard.instantiateViewController(identifier: Constants.Segue.fullScreenSegueIdentifier.rawValue) as? FullScreenPhotoViewController else { return }
        
        guard let pickedImageUrl = photoCellArray[indexPath.item].image else { return }
        let cachedImage = ImageCache.default.retrieveImageInMemoryCache(forKey: pickedImageUrl.absoluteString)
        fullScreenPhotoVC.fullScreenImage = cachedImage
        fullScreenPhotoVC.imageUID = photoCellArray[indexPath.item].uid
        navigationController?.pushViewController(fullScreenPhotoVC, animated: true)
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

