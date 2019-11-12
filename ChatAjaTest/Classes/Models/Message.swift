//
//  Message.swift
//  ChatAjaTest
//
//  Created by Muhammad Nizar on 11/11/19.
//  Copyright © 2019 Muhammad Nizar. All rights reserved.
//

import Foundation
import MessageKit
import FirebaseFirestore

struct Message: MessageType {
    var sender: SenderType {
        return user
    }
    var user:UserModel
    var sentDate: Date
    var kind: MessageKind
    var messageId: String
    var chatId: String
    var message: String
    var senderId: String
    
    init(messageId:String, chatId:String, message:String, senderId:String, sentDate:Date, user:UserModel, kind:MessageKind) {
        self.messageId = messageId
        self.chatId = chatId
        self.message = message
        self.senderId = senderId
        self.sentDate = sentDate
        self.user = user
        self.kind = kind
    }
    
    init?(document: QueryDocumentSnapshot, currentUser:UserModel, opponentUser:UserModel) {
        let data = document.data()
        
        self.messageId = document.documentID
        self.chatId = data["chatId"] as? String ?? ""
        self.message = data["message"] as? String ?? ""
        self.senderId = data["senderID"] as? String ?? ""
        let sentDateTimestamp = data["sentDate"] as? Timestamp
        self.sentDate = sentDateTimestamp?.dateValue() ?? Date()
        
        self.kind = .text(message)
        if (self.senderId == currentUser.userId) {
            self.user = currentUser
        } else {
            self.user = opponentUser
        }
    }
    
}

extension Message: DatabaseRepresentation {
  
  var representation: [String : Any] {
    var rep: [String : Any] = [
      "sentDate": sentDate,
      "senderID": sender.senderId,
    ]
    
    rep["message"] = message
    rep["chatId"] = chatId
    
    return rep
  }
  
}

extension Message: Comparable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.messageId == rhs.messageId
    }
    
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
    
}

