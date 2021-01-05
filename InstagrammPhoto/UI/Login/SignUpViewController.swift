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
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repeatPasswordField: UITextField!
    @IBOutlet weak var accountNickName: UITextField!
    @IBOutlet weak var informMessage: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargetToFields()
        addPlaceholderFieldsConfig()
        
        usernameField?.delegate = self
        passwordField?.delegate = self
        repeatPasswordField?.delegate = self
        accountNickName?.delegate = self
    }
    
    @IBAction func backToLogin(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registrationButtonPressed(_ sender: UIButton) {
        guard usernameField.text?.isEmailValid() == true else {
            informMessage.isHidden = false
            informMessage.text = "Wrong email address!"
            informMessage.textColor = .red
            return
        }
        
        guard passwordField.text?.isPasswordValid() == true else {
            informMessage.isHidden = false
            informMessage.text = "Password should contains min 6 symbols"
            informMessage.textColor = .red
            return
        }
        
        guard passwordField.text == repeatPasswordField.text else {
            informMessage.isHidden = false
            informMessage.text = "Passwords don't matched!"
            informMessage.textColor = .red
            return
        }
        
        Auth.auth().createUser(withEmail: usernameField.text!, password: passwordField.text!) { (result, err) in
            if err != nil {
                print("Error during user creation")
            } else {
                Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).setData([
                    "nick_name": self.accountNickName.text!,
                    "uid": result!.user.uid,
                    "user_status": "",
                    "profile_image": ""
                ]) { (error) in
                    if error != nil {
                        print("Eror during adding user data")
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
    
    func addTargetToFields() {
        usernameField.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                for: .editingChanged)
        repeatPasswordField.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                      for: .editingChanged)
        accountNickName.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                  for: .editingChanged)
    }
    
    func addPlaceholderFieldsConfig() {
        usernameField.attributedPlaceholder = NSAttributedString(string: "Email*", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password*", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        repeatPasswordField.attributedPlaceholder = NSAttributedString(string: "Repeat Password*", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        accountNickName.attributedPlaceholder = NSAttributedString(string: "Account nickname*", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
    }
}

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            signUpButton.isEnabled = false
            signUpButton.alpha = 0.5
        }
        return true
    }
    
    @objc func textFieldsIsNotEmpty(_ textField: UITextField) {
        textField.text = textField.text?.trimmingCharacters(in: .whitespaces)
        
        guard
            let name = usernameField.text, !name.isEmpty,
            let password = passwordField.text, !password.isEmpty,
            let repeatPassword = repeatPasswordField.text, !repeatPassword.isEmpty,
            let accountNickname = accountNickName.text, !accountNickname.isEmpty
        else {
            self.signUpButton.isEnabled = false
            self.signUpButton.alpha = 0.5
            return
        }
        signUpButton.isEnabled = true
        signUpButton.alpha = 1
    }
}
