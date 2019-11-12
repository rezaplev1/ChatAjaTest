//
//  DefaultKeysExtension.swift
//  ChatAjaTest
//
//  Created by Muhammad Nizar on 08/11/19.
//  Copyright © 2019 Muhammad Nizar. All rights reserved.
//

import Foundation
import SwiftyUserDefaults


extension DefaultsKeys {
    static let isUserLoggedIn = DefaultsKey<Bool?>("isUserLoggedIn")
    static let currentUser = DefaultsKey<UserModel?>("currentUser")
    
    static func clearUserData(){
        Defaults.removeAll()
    }
    

}
