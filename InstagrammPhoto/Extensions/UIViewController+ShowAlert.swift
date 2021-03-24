//
//  UIViewController+ShowAlert.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 17.02.21.
//  Copyright © 2021 Maksim Velich. All rights reserved.
//

import UIKit

extension UIViewController {

    public func showAlert(title: String,
                          message: String?,
                          alertStyle:UIAlertController.Style,
                          actionTitles:[String],
                          actionStyles:[UIAlertAction.Style],
                          actions: [((UIAlertAction) -> Void)]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        for(index, indexTitle) in actionTitles.enumerated(){
            let action = UIAlertAction(title: indexTitle, style: actionStyles[index], handler: actions[index])
            alertController.addAction(action)
        }
        self.present(alertController, animated: true)
    }
}
