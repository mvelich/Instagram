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
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var usersArray = [User]()
    private var filteredUsers = [User]()
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    @IBOutlet weak var searchFriendTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = true
        settingsUpSearchBar()
        searchFriendTableView.dataSource = self
        searchFriendTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAllUsers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.view.setNeedsLayout()
        navigationController?.view.layoutIfNeeded()
    }
    
    private func settingsUpSearchBar() {
        navigationItem.titleView = searchController.searchBar
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.searchTextField.textColor = .white
        searchController.hidesNavigationBarDuringPresentation = false
    }
    
    private func fetchAllUsers() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").whereField("uid", isNotEqualTo: currentUserUid).getDocuments{ (querySnapshot, err) in
            if let err = err {
                print("Error getting document: \(err)")
            } else {
                guard let dataSnapShot = querySnapshot?.documents else { return }
                self.usersArray.removeAll()
                for document in dataSnapShot {
                    var user = User()
                    user.profileImage = URL(string: document.get("profile_image") as! String)
                    user.userName = (document.get("nick_name") as! String)
                    user.uid = (document.get("uid") as! String)
                    user.userStatus = (document.get("user_status") as! String)
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
extension AddFriendsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredUsers = usersArray.filter{ ($0.userName?.contains(searchText))! } // forced unwrap
        searchFriendTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension AddFriendsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredUsers.count
        } else {
            return usersArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.reusableTableFriendSearchCellIdentifier.rawValue, for: indexPath) as! FriendSearchTableViewCell
        var user = User()
        if isFiltering {
            user = filteredUsers[indexPath.row]
        } else {
            user = usersArray[indexPath.row]
        }
        cell.userNameLabel.text = user.userName
        let url = user.profileImage
        cell.profileImageView.kf.setImage(with: url)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AddFriendsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user: User
        if isFiltering {
            user = filteredUsers[indexPath.row]
        } else {
            user = usersArray[indexPath.row]
        }
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let uniqUserProfileVC = mainStoryboard.instantiateViewController(withIdentifier: Constants.Segue.uniqUserProfileIdentifier.rawValue) as? UniqUserProfileViewController {
            uniqUserProfileVC.userName = user.userName
            uniqUserProfileVC.userUID = user.uid
            uniqUserProfileVC.profileImage = user.profileImage
            uniqUserProfileVC.userStatus = user.userStatus
            self.navigationController?.pushViewController(uniqUserProfileVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
