//
//  TapeViewController.swift
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

class TapeViewController: UIViewController {
    
    private var photoCellArray = [UserPhoto]()
    private var userData = User()
    
    @IBOutlet weak var instLogoBarButtonItem: UIBarButtonItem! {
        didSet {
            instLogoBarButtonItem.imageInsets = UIEdgeInsets(top: 0, left: -75, bottom: 0, right: 0); // TODO - fix left alignment according to all screens
        }
    }
    
    @IBOutlet weak var tapeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapeTableView.dataSource = self
        tapeTableView.delegate = self
        setInitialPhotoTapeData()
        setInitialUserTapeData()
        self.view.showSpinner()
    }
    
    @IBAction func reloadTapePressed(_ sender: UIBarButtonItem) {
        setInitialPhotoTapeData()
        tapeTableView.scrollToTop(animated: true)
    }
    
    func setInitialUserTapeData() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(currentUserUid).getDocument() { (document, err) in
            if let err = err {
                print("Error getting document: \(err)")
            } else {
                self.userData.userName = (document?.get("nick_name") as! String)
                self.userData.profileImage = URL(string: document?.get("profile_image") as! String)
                DispatchQueue.main.async {
                    self.tapeTableView.reloadData()
                }
            }
        }
    }
    
    func setInitialPhotoTapeData() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(currentUserUid).collection("photos").getDocuments { (querySnapshot, err) in
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
                    self.photoCellArray.append(photo)
                }
                DispatchQueue.main.async {
                    self.tapeTableView.reloadData()
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension TapeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoCellArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tapeTableView.dequeueReusableCell(withIdentifier: Constants.Cell.reusableTableCellIdentifier.rawValue, for: indexPath) as! TapeTableViewCell
        // photo data
        photoCellArray = photoCellArray.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        let photoCellObject = photoCellArray[indexPath.row]
        let url = photoCellObject.image
        cell.tapeImgae.kf.setImage(with: url)
        cell.likeLabel.text = String(photoCellObject.likes ?? 0)
        cell.place.text = photoCellObject.location
        cell.imageDescription.text = photoCellObject.description
        // user data
        cell.friendNameTop.text = userData.userName
        cell.friendNameButtom.text = userData.userName
        let urlProfileImage = userData.profileImage
        cell.userProfileImage.kf.setImage(with: urlProfileImage)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TapeViewController: UITableViewDelegate {
   
}
