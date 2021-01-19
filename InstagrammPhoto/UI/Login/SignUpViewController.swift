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
        
        Auth.auth().createUser(withEmail: usernameTextField.text!, password: passwordTextField.text!) { (result, err) in
            if err != nil {
                print("Error during user creation")
            } else {
                let imageLocation = Storage.storage().reference().child("profile_images").child("default_profile_image.png")
                
                imageLocation.downloadURL { url, error in
                    guard let downloadURL = url else {
                        print("There is no download URL")
                        return
                    }
                    
                    Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).setData([
                        "nick_name": self.accountNickNameTextField.text!,
                        "uid": result!.user.uid,
                        "user_status": "",
                        "profile_image": "\(downloadURL)"
                    ]) { (error) in
                        if error != nil {
                            print("Eror during adding user data")
                        }
                    }
                }
            }
        }
        showRegistrationAlert()
    }
    
    func showRegistrationAlert() {
        let alert = UIAlertController(title: "Registration successfully completed", message: "Click Ok! button to proceed", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok!", style: .default, handler: {_ in self.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
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
