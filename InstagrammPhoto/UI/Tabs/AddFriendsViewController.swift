//
//  AddFriendsViewController.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 11/24/20.
//  Copyright © 2020 Maksim Velich. All rights reserved.
//

import UIKit

class AddFriendsViewController: UIViewController {
    let databaseLogicHandler = DatabaseLogicHandler()
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.delegate = self
    }
    
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        // check if we have users in base with entering name, try to do it in realm time entering by char
    }
}

extension AddFriendsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
}
