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
    let semaphore = DispatchSemaphore(value: 0)
    let db = Firestore.firestore()
    let currentUserUid = Auth.auth().currentUser?.uid
    let profileImagesStorageRef = Storage.storage().reference().child("profile_images")
    var imagePicker = UIImagePickerController()
    let imageName = UUID().uuidString
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userStatusField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        profileImageView.setRounded()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        updateUserProfileData()
        // change this code to progress loader after
        let seconds = 5.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            let profileVc = segue.destination as! ProfileViewController
            profileVc.setInitialUserData()
        }
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
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func uploadUserImage() {
        let data = profileImageView.image!.pngData()
        let imageLocation = profileImagesStorageRef.child("\(imageName)")
        imageLocation.putData(data!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                print("Error druing miage upload")
                return
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK:UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else { return }
        self.profileImageView.image = image
    }
    
    //MARK:Database logic handle
    func updateUserProfileData() {
            if self.userStatusField.text != "" && self.profileImageView.image != nil {
            // uploadUserImage()
                let data = self.profileImageView.image!.pngData()
                let imageLocation = self.profileImagesStorageRef.child("\(self.imageName)")
            imageLocation.putData(data!, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    print("Error druing miage upload")
                    return
                }
                
                imageLocation.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        print("There is no download URL")
                        return
                    }
                    
                    self.db.collection("users").document(self.currentUserUid!).updateData([
                        "user_status": "\(self.userStatusField.text!)",
                        "profile_image": "\(downloadURL)"
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated!")
                        }
                    }
                }
            }
            
        } else {
            print("Check if you select both: picture and status")
        }
    }
}
