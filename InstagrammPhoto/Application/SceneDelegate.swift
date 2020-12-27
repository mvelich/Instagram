//
//  SceneDelegate.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 11/15/20.
//  Copyright © 2020 Maksim Velich. All rights reserved.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loggedUsername = UserDefaults.standard.string(forKey: "username"), Auth.auth().currentUser != nil {
            
            let tabBarViewController = storyboard.instantiateViewController(identifier: "TabBarViewController")
            window?.rootViewController = tabBarViewController
        } else {
            let signInViewController = storyboard.instantiateViewController(identifier: "SignInViewController")
            window?.rootViewController = signInViewController
        }
    }
    
    func changeRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard let window = self.window else {
            return
        }
        
        window.rootViewController = vc
        UIView.transition(with: window, duration: 0.5, options: [.transitionFlipFromLeft], animations: nil, completion: nil)
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
}

