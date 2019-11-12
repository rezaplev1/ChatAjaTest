//
//  AppDelegate+RootVC.swift
//  ChatAjaTest
//
//  Created by Muhammad Nizar on 08/11/19.
//  Copyright © 2019 Muhammad Nizar. All rights reserved.
//

import Foundation
import UIKit

extension SceneDelegate {

    func setRootHomePage() {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        window?.rootViewController = UINavigationController(rootViewController: homeViewController)
        window?.makeKeyAndVisible()
        
        UIView.transition(with: window!, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    }
    
    func setRootLoginPage() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        UIView.transition(with: window!, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    }
    
}
