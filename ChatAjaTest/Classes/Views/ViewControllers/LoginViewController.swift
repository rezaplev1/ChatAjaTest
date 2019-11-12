//
//  LoginViewController.swift
//  ChatAjaTest
//
//  Created by Muhammad Nizar on 09/11/19.
//  Copyright © 2019 Muhammad Nizar. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class LoginViewController: UIViewController {
    
    @IBOutlet private weak var userNameTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var passwordTextField: SkyFloatingLabelTextField!
    private var loginViewModel:LoginViewModel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        loginViewModel = LoginViewModel()
        loginViewModel.delegate = self
    }
    
    @IBAction func loginButtonDidClicked(_ sender:UIButton) {
        loginViewModel.login(username: userNameTextField.text ?? "", password: passwordTextField.text ?? "")
    }

}

// MARK : - LoginViewModelDelegate
extension LoginViewController: LoginViewModelDelegate {
    func showLoading() {
        showLoadingHUD()
    }
    
    func hideLoading() {
        hideLoadingHUD()
    }
    
    func successLogin(name:String) {
        SceneDelegate.sharedSceneDelegate()?.setRootHomePage()
    }
    
    func failedLogin(message: String) {
        showPopupAlert(title: NSLocalizedString("Login Failed", comment: ""),
                       message: message,
                       actionTitles: ["Ok"],
                       actions:[{action1 in },nil])
    }
    
    
}
