//
//  String+IsValid.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 1.12.20.
//  Copyright © 2020 Maksim Velich. All rights reserved.
//

import Foundation

extension String {
    
    func isEmailValid() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isPasswordValid() -> Bool {
        let passwordRegEx = ".{6,}"
        let passwordTest = NSPredicate(format:"SELF MATCHES[c] %@", passwordRegEx)
        return passwordTest.evaluate(with: self)
    }
}
