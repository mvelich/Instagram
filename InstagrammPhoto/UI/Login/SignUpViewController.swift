//
//  SignUpViewController.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 11/15/20.
//  Copyright © 2020 Maksim Velich. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField! {
        didSet {
            usernameTextField?.delegate = self
            usernameTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
            usernameTextField.attributedPlaceholder = NSAttributedString(
                string: "Email*", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField?.delegate = self
            passwordTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
            passwordTextField.attributedPlaceholder = NSAttributedString(
                string: "Password*", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        }
    }
    @IBOutlet weak var repeatPasswordTextField: UITextField! {
        didSet {
            repeatPasswordTextField?.delegate = self
            repeatPasswordTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
            repeatPasswordTextField.attributedPlaceholder = NSAttributedString(
                string: "Repeat Password*", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        }
    }
    @IBOutlet weak var accountNickNameTextField: UITextField! {
        didSet {
            accountNickNameTextField?.delegate = self
            accountNickNameTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
            accountNickNameTextField.attributedPlaceholder = NSAttributedString(
                string: "Account nickname*", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        }
    }
    @IBOutlet weak var informMessage: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backToLogin(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registrationButtonPressed(_ sender: UIButton) {
        guard usernameTextField.text?.isEmailValid() == true else {
            informMessage.isHidden = false
            informMessage.text = "Wrong email address!"
            informMessage.textColor = .red
            return
        }
        
        guard passwordTextField.text?.isPasswordValid() == true else {
            informMessage.isHidden = false
            informMessage.text = "Password should contains min 6 symbols"
            informMessage.textColor = .red
            return
        }
        
        guard passwordTextField.text == repeatPasswordTextField.text else {
            informMessage.isHidden = false
            informMessage.text = "Passwords don't matched!"
            informMessage.textColor = .red
            return
        }
        
        guard let userName = usernameTextField.text, let password = passwordTextField.text else { return }
        guard let accountNickname = accountNickNameTextField.text else { return }
        
        Firestore.firestore().collection("users").whereField("nick_name", isEqualTo: accountNickname).getDocuments { (querysnapshot, error) in
            if error != nil {
                print("Error getting documents")
            } else {
                if let document = querysnapshot?.documents, !document.isEmpty {
                    self.informMessage.isHidden = false
                    self.informMessage.text = "Nickname is already in use!"
                    self.informMessage.textColor = .red
                    return
                } else {
                    Auth.auth().createUser(withEmail: userName, password: password) { (result, err) in
                        if err != nil {
                            print("Error during user creation")
                        } else if let result = result {
                            let imageLocation = Storage.storage().reference().child("profile_images").child("default_profile_image.png")
                            
                            imageLocation.downloadURL { url, error in
                                guard let downloadURL = url else {
                                    print("There is no download URL")
                                    return
                                }
                                
                                guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
                                Firestore.firestore().collection("users").document(currentUserUid).setData([
                                    "nick_name": self.accountNickNameTextField.text ?? "default name",
                                    "uid": result.user.uid,
                                    "user_status": "",
                                    "profile_image": "\(downloadURL)"
                                ]) { (error) in
                                    if error != nil {
                                        print("Eror during adding user data")
                                    }
                                }
                            }
                        } else {
                            return
                        }
                    }
                    self.showAlert(title: "Registration successfully completed", message: "Click Ok! button to proceed", alertStyle: .alert, actionTitles: ["Ok!"], actionStyles: [.default], actions: [
                        {_ in
                            self.dismiss(animated: true, completion: nil)
                        }
                    ])
                }
            }
        }
    }
}

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text?.isEmpty == true {
            signUpButton.isEnabled = false
            signUpButton.alpha = 0.5
        }
        return true
    }
    
    @objc func textFieldsIsNotEmpty(_ textField: UITextField) {
        textField.text = textField.text?.trimmingCharacters(in: .whitespaces)
        
        guard
            let name = usernameTextField.text, !name.isEmpty,
            let password = passwordTextField.text, !password.isEmpty,
            let repeatPassword = repeatPasswordTextField.text, !repeatPassword.isEmpty,
            let accountNickname = accountNickNameTextField.text, !accountNickname.isEmpty
        else {
            self.signUpButton.isEnabled = false
            self.signUpButton.alpha = 0.5
            return
        }
        signUpButton.isEnabled = true
        signUpButton.alpha = 1
    }
}
