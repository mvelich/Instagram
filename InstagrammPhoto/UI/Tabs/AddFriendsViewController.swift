//
//  AddFriendsViewController.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 11/24/20.
//  Copyright © 2020 Maksim Velich. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class AddFriendsViewController: UIViewController {
    
    private var usersArray = [User]()
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchFriendTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.delegate = self
        searchFriendTableView.dataSource = self
        searchFriendTableView.delegate = self
        fetchAllUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        
    }
    
    private func fetchAllUsers() {
        Firestore.firestore().collection("users").getDocuments{ (querySnapshot, err) in
            if let err = err {
                print("Error getting document: \(err)")
            } else {
                guard let dataSnapShot = querySnapshot?.documents else { return }
                for document in dataSnapShot {
                    var user = User()
                    user.profileImage = URL(string: document.get("profile_image") as! String)
                    user.userName = (document.get("nick_name") as! String)
                    user.uid = (document.get("uid") as! String)
                    self.usersArray.append(user)
                }
                DispatchQueue.main.async {
                    self.searchFriendTableView.reloadData()
                }
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension AddFriendsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
}

// MARK: - UITableViewDataSource
extension AddFriendsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.reusableTableFriendSearchCellIdentifier.rawValue, for: indexPath) as! FriendSearchTableViewCell
        let user = usersArray[indexPath.row]
        cell.userNameLabel.text = user.userName
        let url = user.profileImage
        cell.profileImageView.kf.setImage(with: url)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AddFriendsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = usersArray[indexPath.row]
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let uniqUserProfileVC = mainStoryboard.instantiateViewController(withIdentifier: Constants.Segue.uniqUserProfileIdentifier.rawValue) as? UniqUserProfileViewController {
            uniqUserProfileVC.userName = user.userName
            uniqUserProfileVC.userUID = user.uid
            self.navigationController?.pushViewController(uniqUserProfileVC, animated: true)
        }
    }
}
