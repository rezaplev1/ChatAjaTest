//
//  LoginViewModel.swift
//  ChatAjaTest
//
//  Created by Muhammad Nizar on 09/11/19.
//  Copyright © 2019 Muhammad Nizar. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import FirebaseFirestore

protocol LoginViewModelDelegate : class {
    func showLoading()
    func hideLoading()
    func successLogin(name:String)
    func failedLogin(message: String)
}

class LoginViewModel {
    
    weak var delegate: LoginViewModelDelegate?
    let userManager = UserManager()
    
    func login(username:String, password:String) {
        if (username.isEmpty == true || password.isEmpty == true) {
            delegate?.failedLogin(message: "Please input your username and password")
            return
        }
        delegate?.showLoading()
        userManager.login(email: username, password: password, success: {(currentUser) in
            self.userManager.getUser(withUserId: currentUser.uid, completion: {(userModel) in
                Defaults[.isUserLoggedIn] = true
                Defaults[.currentUser] = userModel
                self.delegate?.hideLoading()
                self.delegate?.successLogin(name: userModel.name)
            })
        }, failure: { (errorMessage) in
            self.delegate?.hideLoading()
            self.delegate?.failedLogin(message: errorMessage)
        })
    }

}
