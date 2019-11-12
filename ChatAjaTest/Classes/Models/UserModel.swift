//
//  User.swift
//  ChatAjaTest
//
//  Created by Muhammad Nizar on 11/11/19.
//  Copyright © 2019 Muhammad Nizar. All rights reserved.
//

import Foundation
import FirebaseFirestore
import SwiftyUserDefaults
import MessageKit

struct UserModel: Codable, DefaultsSerializable, SenderType {

    var name: String
    var email: String
    var userId:String
    var avatarUrl: String
    var senderId: String
    var displayName: String
    
    init(name:String, email:String, userId:String, avatarUrl:String) {
        self.name = name
        self.email = email
        self.userId = userId
        self.avatarUrl = avatarUrl
        self.senderId = userId
        self.displayName = name
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        self.userId = data["userId"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.avatarUrl = data["avatarUrl"] as? String ?? ""
        self.senderId = self.userId
        self.displayName = self.name
    }
    
}

extension UserModel: Comparable {
    static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        return lhs.userId == rhs.userId
    }
    
    static func < (lhs: UserModel, rhs: UserModel) -> Bool {
        return lhs.userId < rhs.userId
    }
    
}
