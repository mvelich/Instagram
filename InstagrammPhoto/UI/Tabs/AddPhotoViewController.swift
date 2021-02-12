//
//  AddPhotoViewController.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 27.12.20.
//  Copyright © 2020 Maksim Velich. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class AddPhotoViewController: UIViewController {
    
    var imagePicker = UIImagePickerController()
    var callback: (() -> ())?
    
    @IBOutlet weak var newImageView: UIImageView!
    @IBOutlet weak var locationNameField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        guard self.newImageView.image != nil else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        guard let data = self.newImageView.image?.jpegData(compressionQuality: 0.5) else { return }
        let imageLocation = Storage.storage().reference().child("\(UUID().uuidString)")
        imageLocation.putData(data, metadata: nil) { (_, error) in
            
            imageLocation.downloadURL { (url, error) in
                guard let downloadURL = url else { return }
                
                guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
                Firestore.firestore().collection("users").document(currentUserUid).collection("photos").addDocument(data: [
                    "image": "\(downloadURL)",
                    "location": "\(self.locationNameField.text ?? "")",
                    "description": "\(self.descriptionField.text ?? "")",
                    "likes": 0,
                    "date": Date()
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err.localizedDescription)")
                    }
                }
            }
        }
        
        navigationItem.showRightButtonActivityIndicator {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func selectButtonPressed(_ sender: UIButton) {
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
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

//MARK: - UIImagePickerControllerDelegate
extension AddPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else { return }
        self.newImageView.image = image
    }
}
