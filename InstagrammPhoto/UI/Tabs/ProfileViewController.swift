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
        showSpinner()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editProfileVc = segue.destination as? EditProfileViewController {
            if let status = userStatus.text {
                editProfileVc.currentProfileStatus = status
            }
        }
    }
    
    @IBAction func editProfilePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "EditProfileViewController", sender: self)
    }
    
    @IBAction func addPhotoPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "AddPhotoViewController", sender: self)
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signInViewController = storyboard.instantiateViewController(identifier: "SignInViewController")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(signInViewController)
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) { }
    
    //MARK: - Internal methods
    
    internal func showSpinner() {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.backgroundColor = UIColor(white: 0, alpha: 0.8)
        spinner.color = .red
        self.view.addSubview(spinner)
        spinner.frame = self.view.frame
        let delay = 4
        spinner.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            spinner.stopAnimating()
        }
    }
    
    internal func setInitialUserData() {
        Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).getDocument() { (document, err) in
            if let err = err {
                print("Error getting document: \(err)")
            } else {
                self.userStatus.text = (document?.get("user_status") as! String)
                self.profileName.text = (document?.get("nick_name") as! String)
                let url = URL(string: document?.get("profile_image") as! String)
                self.profileImage.kf.setImage(with: url)
            }
        }
    }
    
    internal func updateProfilePhotos() {
        Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).collection("photos").getDocuments { (querySnapshot, err) in
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

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostThumbImageCell", for: indexPath) as! PostThumbImageCell
        let url = imagesArray[indexPath.item]
        cell.photoImage.loadUsingUrl(url: url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
