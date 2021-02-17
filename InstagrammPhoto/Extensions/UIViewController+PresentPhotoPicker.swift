//
//  UIViewController+ShowImagePicker.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 17.02.21.
//  Copyright © 2021 Maksim Velich. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentPhotoPicker(imagePicker: UIImagePickerController, sourceType: UIImagePickerController.SourceType) {
        switch sourceType {
        case .camera:
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                self.showAlert(title: "Warning!", message: "Run on real device or give permission", alertStyle: .alert, actionTitles: ["Ok!"], actionStyles: [.default], actions: [{_ in return }])
            }
        case .photoLibrary:
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                imagePicker.allowsEditing = true
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                self.showAlert(title: "Warning!", message: "You don't have permission to access gallery", alertStyle: .alert, actionTitles: ["Ok!"], actionStyles: [.default], actions: [{_ in return }])
            }
        default:
            return
        }
    }    
}
