//
//  Chat.swift
//  ChatAjaTest
//
//  Created by Muhammad Nizar on 11/11/19.
//  Copyright © 2019 Muhammad Nizar. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Chat {
    
    var chatId: String
    var userIDs = [String]()
    var lastMessage: String
    var lastMessageDate: Date?
    
    init(chatId:String, userIDs:[String], lastMessage:String, lastMessageDate:Date) {
        self.chatId = chatId
        self.userIDs = userIDs
        self.lastMessage = lastMessage
        self.lastMessageDate = lastMessageDate
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        self.chatId = document.documentID
        self.userIDs = data["userIDs"] as? [String] ?? []
        self.lastMessage = data["lastMessage"] as? String ?? ""
        let lastMessageTimestamp = data["lastMessageTimestamp"] as? Timestamp
        self.lastMessageDate = lastMessageTimestamp?.dateValue()
    }
    
}

extension Chat: Comparable {
    static func == (lhs: Chat, rhs: Chat) -> Bool {
        return lhs.chatId == rhs.chatId
    }
    
    static func < (lhs: Chat, rhs: Chat) -> Bool {
        return lhs.chatId < rhs.chatId
    }
    
}
