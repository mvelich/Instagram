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
    @IBOutlet weak var usernameTextField: UITextField! {
        didSet {
            usernameTextField?.delegate = self
            usernameTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
            usernameTextField.attributedPlaceholder = NSAttributedString(
                string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField?.delegate = self
            passwordTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
            passwordTextField.attributedPlaceholder = NSAttributedString(
                string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        }
    }
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var informLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        #if DEBUG
        usernameTextField.text = "test@corevist.com"
        passwordTextField.text = "123456"
        textFieldsIsNotEmpty(passwordTextField)
        #endif
    }
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        guard let userName = usernameTextField.text, let password = passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: userName, password: password) { (result, error) in
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
        performSegue(withIdentifier: Constants.Segue.signUpSegueIdentifier.rawValue, sender: self)
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text?.isEmpty == true {
            signInButton.isEnabled = false
            signInButton.alpha = 0.5
        }
        return true
    }
    
    @objc func textFieldsIsNotEmpty(_ textField: UITextField) {
        textField.text = textField.text?.trimmingCharacters(in: .whitespaces)
        
        guard
            let name = usernameTextField.text, !name.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
        else {
            self.signInButton.isEnabled = false
            self.signInButton.alpha = 0.5
            return
        }
        signInButton.isEnabled = true
        signInButton.alpha = 1
    }
}
