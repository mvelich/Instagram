//
//  EditProfileViewController.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 5.12.20.
//  Copyright © 2020 Maksim Velich. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class EditProfileViewController: UIViewController {
    
    var imagePicker = UIImagePickerController()
    var currentProfileStatus: String?
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userStatusField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userStatusField.text = currentProfileStatus
        imagePicker.delegate = self
        profileImageView.setRounded()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let profileVc = segue.destination as! ProfileViewController
        
        guard self.userStatusField.text != currentProfileStatus || self.profileImageView.image != nil else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        if let profileImage = self.profileImageView.image {
            let data = profileImage.pngData()
            let imageLocation = Storage.storage().reference().child("profile_images").child("\(UUID().uuidString)")
            imageLocation.putData(data!, metadata: nil) { (_, error) in
                
                imageLocation.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        print("There is no download URL")
                        return
                    }
                    
                    Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).updateData([
                        "user_status": "\(self.userStatusField.text!)",
                        "profile_image": "\(downloadURL)"
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated!")
                        }
                        profileVc.setInitialUserData()
                    }
                }
            }
        } else {
            Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).updateData([
                "user_status": "\(self.userStatusField.text!)",
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated!")
                }
                profileVc.setInitialUserData()
            }
        }
        CommonFunctions.showSpinner(profileVc.view)
    }
    
    @IBAction func selectImagePressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) { }
}

// MARK: - UIImagePickerControllerDelegate
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else { return }
        self.profileImageView.image = image
    }
}
