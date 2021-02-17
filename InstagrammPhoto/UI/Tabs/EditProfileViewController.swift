//
//  EditProfileViewController.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 5.12.20.
//  Copyright © 2020 Maksim Velich. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class EditProfileViewController: UITableViewController {
    
    var imagePicker = UIImagePickerController()
    var currentProfileStatus: String?
    var currentProfileImage: UIImage?
    var callback: (() -> ())?
    
    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileImageViewTapped)))
        }
    }
    @IBOutlet weak var userStatusTextField: UITextField! {
        didSet {
            userStatusTextField?.delegate = self
            userStatusTextField.attributedPlaceholder = NSAttributedString(
                string: "Status", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        }
    }
    @IBOutlet weak var userNameTextField: UITextField! {
        didSet {
            userNameTextField?.delegate = self
            userNameTextField.attributedPlaceholder = NSAttributedString(
                string: "Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userStatusTextField.text = currentProfileStatus
        profileImageView.image = currentProfileImage
        imagePicker.delegate = self
        profileImageView.setRounded()
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        guard self.userStatusTextField.text != currentProfileStatus || self.profileImageView.image != currentProfileImage else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        
        if let profileImage = self.profileImageView.image {
            guard let data = profileImage.jpegData(compressionQuality: 0.5) else { return }
            let imageLocation = Storage.storage().reference().child("profile_images").child("\(UUID().uuidString)")
            imageLocation.putData(data, metadata: nil) { (_, error) in
                
                imageLocation.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        print("There is no download URL")
                        return
                    }
                    
                    Firestore.firestore().collection("users").document(currentUserUid).updateData([
                        "user_status": "\(self.userStatusTextField.text ?? "")",
                        "profile_image": "\(downloadURL)"
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated!")
                        }
                        self.callback?()
                    }
                }
            }
        } else {
            Firestore.firestore().collection("users").document(currentUserUid).updateData([
                "user_status": "\(self.userStatusTextField.text ?? "")",
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated!")
                }
                self.callback?()
            }
        }
        
        navigationItem.showRightButtonActivityIndicator {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func profileImageViewTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.showAlert(title: "Select Image", message: nil, alertStyle: .actionSheet, actionTitles: ["Camera", "Gallery", "Cancel"], actionStyles: [.default, .default, .cancel], actions: [
            {_ in
                self.openCamera()
            },
            {_ in
                self.openGallery()
            },
            {_ in
                return
            }
        ])
    }
    
    @IBAction func selectImagePressed(_ sender: UIButton) {
        self.showAlert(title: "Select Image", message: nil, alertStyle: .actionSheet, actionTitles: ["Camera", "Gallery", "Cancel"], actionStyles: [.default, .default, .cancel], actions: [
            {_ in
                self.openCamera()
            },
            {_ in
                self.openGallery()
            },
            {_ in
                return
            }
        ])
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            self.showAlert(title: "Warning!", message: "Run on real device or give permission", alertStyle: .alert, actionTitles: ["Ok!"], actionStyles: [.default], actions: [{_ in return }])
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            self.showAlert(title: "Warning!", message: "You don't have permission to access gallery", alertStyle: .alert, actionTitles: ["Ok!"], actionStyles: [.default], actions: [{_ in return }])
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else { return }
        self.profileImageView.image = image
    }
}

//MARK: - UITextFieldDelegate
extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
