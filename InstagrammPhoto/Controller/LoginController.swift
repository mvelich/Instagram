//
//  LoginController.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 11/15/20.
//  Copyright © 2020 Maksim Velich. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    let databaseLogicHandler = DatabaseLogicHandler()
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
          super.viewDidLoad()
      }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
       let userAcess =  databaseLogicHandler.accessToLogin(userName: userNameTextField.text!, userPassword: passwordTextField.text!)
        
        if userAcess == true {
            performSegue(withIdentifier: "userLoggedIn", sender: self)
        } else {
            print("User name or password incorrect")
            print(userAcess)
        }
        
    }
    
    @IBAction func backToWelcomePressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
