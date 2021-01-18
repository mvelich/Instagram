//
//  ViewController.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 11/15/20.
//  Copyright © 2020 Maksim Velich. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var mainInstLogo: UIImageView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var informLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargetToFields()
        addPlaceholderFieldsConfig()
        
        usernameField?.delegate = self
        passwordField?.delegate = self
        #if DEBUG
        usernameField.text = "test@corevist.com"
        passwordField.text = "123456"
        textFieldsIsNotEmpty(passwordField)
        #endif
    }
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: usernameField.text!, password: passwordField.text!) { (result, error) in
            if error != nil {
                self.informLabel.text = "Name or password are incorrect!"
                self.informLabel.textColor = .red
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabBarController = storyboard.instantiateViewController(identifier: "TabBarViewController")
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(tabBarController)
            }
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "userRegistration", sender: self)
    }
    
    func addTargetToFields() {
        usernameField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
    }
    
    func addPlaceholderFieldsConfig() {
        usernameField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            signInButton.isEnabled = false
            signInButton.alpha = 0.5
        }
        return true
    }
    
    @objc func textFieldsIsNotEmpty(_ textField: UITextField) {
        textField.text = textField.text?.trimmingCharacters(in: .whitespaces)
        
        guard
            let name = usernameField.text, !name.isEmpty,
            let password = passwordField.text, !password.isEmpty
        else {
            self.signInButton.isEnabled = false
            self.signInButton.alpha = 0.5
            return
        }
        signInButton.isEnabled = true
        signInButton.alpha = 1
    }
}
