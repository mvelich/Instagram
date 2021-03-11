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

class AddPhotoViewController: UITableViewController {
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var newImageView: UIImageView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var descriptionField: UITextField! {
        didSet {
            descriptionField?.delegate = self
            descriptionField.attributedPlaceholder = NSAttributedString(
                string: "Add description", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func unwind(_ sender: UIStoryboardSegue) {
        if let senderVC = sender.source as? MapViewController {
            locationNameLabel.text = senderVC.locationLabel.text
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        guard self.newImageView.image?.pngData() != UIImage(named: "add_photo")?.pngData() else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        guard let data = self.newImageView.image?.jpegData(compressionQuality: 0.5) else { return }
        let photoUID = UUID().uuidString
        let imageLocation = Storage.storage().reference().child("\(photoUID)")
        imageLocation.putData(data, metadata: nil) { (_, error) in
            
            imageLocation.downloadURL { (url, error) in
                guard let downloadURL = url else { return }
                
                guard let photoDescription = self.descriptionField.text else { return }
                guard let photoLocation = self.locationNameLabel.text else { return }
                let rightPhotoLocation = photoLocation != "Add location" ? photoLocation : ""
                guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
                Firestore.firestore().collection("users").document(currentUserUid).collection("photos").document(photoUID).setData([
                    "image": "\(downloadURL)",
                    "location": "\(rightPhotoLocation)",
                    "description": "\(photoDescription)",
                    "likes": 0,
                    "date": Date(),
                    "uid": photoUID
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
}

//MARK: - UIImagePickerControllerDelegate
extension AddPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else { return }
        newImageView.image = image
    }
}

//MARK: - UITextFieldDelegate
extension AddPhotoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - UITableViewDelegate
extension AddPhotoViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.showAlert(title: "Select Image", message: nil, alertStyle: .actionSheet, actionTitles: ["Camera", "Gallery", "Cancel"], actionStyles: [.default, .default, .cancel], actions: [
                {_ in
                    self.presentPhotoPicker(imagePicker: self.imagePicker, sourceType: .camera)
                },
                {_ in
                    self.presentPhotoPicker(imagePicker: self.imagePicker, sourceType: .photoLibrary)
                },
                {_ in
                    return
                }
            ])
        }
    }
}
