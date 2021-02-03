//
//  IndividualUserProfileViewController.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 26.01.21.
//  Copyright © 2021 Maksim Velich. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class UniqUserProfileViewController: UIViewController {
    
    private var imagesArray = [URL]()
    var userName: String?
    var userUID: String?
    var profileImage: URL?
    var userStatus: String?
    
    @IBOutlet weak var photoGridCollectionView: UICollectionView!
    @IBOutlet weak var uniqUserProfileImage: UIImageView!
    @IBOutlet weak var userStatusLabel: UILabel!
    @IBOutlet weak var postNumberLabel: UILabel!
    @IBOutlet weak var followersNumberLabel: UILabel!
    @IBOutlet weak var followUserButton: UIButton!
    @IBOutlet weak var followingNumberLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton! {
        didSet {
            messageButton.addGreyBorder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        uniqUserProfileImage.setRounded()
        photoGridCollectionView.delegate = self
        photoGridCollectionView.dataSource = self
        setInitialUserData()
        updateProfilePhotos()
        photoGridCollectionView.collectionViewLayout = LeftAlignmentFlowLayout(minimumInteritemSpacing: 2, minimumLineSpacing: 2)
    }
    
    func setInitialUserData() {
        navigationItem.title = userName
        userStatusLabel.text = userStatus
        uniqUserProfileImage.kf.setImage(with: profileImage)
    }
    
    func updateProfilePhotos() {
        guard let currentUserUid = userUID else { return }
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

//MARK: - UICollectionViewDataSource
extension UniqUserProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cell.reusableCollectionFriendPhotoCellIdentifier.rawValue,
                                                      for: indexPath) as! FriendPhotoCollectionViewCell
        let url = imagesArray[indexPath.row]
        cell.photoImageView.kf.setImage(with: url)
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension UniqUserProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
