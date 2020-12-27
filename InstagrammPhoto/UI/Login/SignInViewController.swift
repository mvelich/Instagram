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
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var informLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ADD IN NEW METHOD
        usernameField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
        
        usernameField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        //засетать в сториборде
        logInButton.isEnabled = false
        logInButton.alpha = 0.5
        
        usernameField?.delegate = self
        passwordField?.delegate = self
        #if DEBUG
        usernameField.text = "1"
        passwordField.text = "1"
        textFieldsIsNotEmpty(passwordField)
        #endif
    }
    
    // 2 actions
    @IBAction func userChoicePressed(_ sender: UIButton) {
        if sender.currentTitle == "Sign In" {
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
        } else {
            performSegue(withIdentifier: "userRegistration", sender: self)
        }
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            logInButton.isEnabled = false
            logInButton.alpha = 0.5
        }
        return true
    }
    
    @objc func textFieldsIsNotEmpty(_ textField: UITextField) {
        textField.text = textField.text?.trimmingCharacters(in: .whitespaces)
        
        if let name = usernameField.text, !name.isEmpty, let password = passwordField.text, !password.isEmpty {
            self.logInButton.isEnabled = false
            self.logInButton.alpha = 0.5
        } else {
            logInButton.isEnabled = true
            logInButton.alpha = 1
        }
    }
}
