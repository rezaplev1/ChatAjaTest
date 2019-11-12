//
//  ChatViewModel.swift
//  ChatAjaTest
//
//  Created by Muhammad Nizar on 12/11/19.
//  Copyright © 2019 Muhammad Nizar. All rights reserved.
//

import Foundation
import FirebaseFirestore
import SwiftyUserDefaults
import MessageKit

protocol ChatViewModelDelegate : class {
    func showLoading()
    func hideLoading()
    func didGetAllMessagesSuccess(messages:[Message])
    func didGetAllMessagesError(message: String)
    func insertRow(atIndex index:Int)
    func updateRow(atIndex index:Int)
    func deleteRow(atIndex index:Int)
}

class ChatViewModel {
    
    weak var delegate: ChatViewModelDelegate?
    private let db = Firestore.firestore()
    
    private var messageReference: CollectionReference {
        return db.collection("messages")
    }
    
    private var messageListener: ListenerRegistration?
    var messages = [Message]()
    var chat:Chat!
    var currentUser: UserModel!
    var opponentUser: UserModel!
    
    init(chat:Chat, currentUser:UserModel, opponentUser:UserModel) {
        self.chat = chat
        self.currentUser = currentUser
        self.opponentUser = opponentUser
    }
    
    func insertMessage(_ messageString:String) {
        let currentDate = Date()
        let message = Message(messageId: UUID().uuidString, chatId: chat.chatId, message: messageString, senderId: currentUser.senderId, sentDate: currentDate, user: currentUser, kind: .text(messageString))
        messageReference.addDocument(data: message.representation) { error in
          if let e = error {
            print("Error sending message: \(e.localizedDescription)")
            return
            }
            self.updateChat(self.chat.chatId, message: messageString, date: currentDate)
        }
    }
    
    func updateChat(_ chatId:String, message:String, date:Date) {
        db.collection("chats")
        .whereField("chatId", isEqualTo: chatId)
        .getDocuments() { (querySnapshot, err) in
            if let err = err {
                // Some error occured
                print("error updateChat :\(err.localizedDescription)")
            } else if querySnapshot!.documents.count != 1 {
                // Perhaps this is an error for you?
            } else {
                let document = querySnapshot!.documents.first
                document?.reference.updateData([
                    "lastMessage": message,
                    "lastMessageTimestamp":date
                ])
            }
        }
    }
    
    func observerMessageListener() {
        print("self.chat.chatId:===\(self.chat.chatId)===")
        messageListener = messageReference.whereField("chatId", isEqualTo: chat.chatId).addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
            }
        }
    }
    
    private func handleDocumentChange(_ change: DocumentChange) {
        guard let message = Message(document: change.document, currentUser: self.currentUser, opponentUser: self.opponentUser) else {
            return
        }
        
        switch change.type {
        case .added:
            addMessageToTable(message)
            
        case .modified:
            updateMessageInTable(message)
            
        case .removed:
            removeMessageFromTable(message)
        }
    }
    
    private func addMessageToTable(_ message: Message) {
        guard !messages.contains(message) else {
            return
        }
        
        messages.append(message)
        messages.sort()
        
        guard let index = messages.firstIndex(of: message) else {
            return
        }
        print("index addMessagesToTable :\(index)")
        self.delegate?.insertRow(atIndex: index)
        // tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func updateMessageInTable(_ message: Message) {
        guard let index = messages.firstIndex(of: message) else {
            return
        }
        
        messages[index] = message
        self.delegate?.updateRow(atIndex: index)
        //tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func removeMessageFromTable(_ message: Message) {
        guard let index = messages.firstIndex(of: message) else {
            return
        }
        
        messages.remove(at: index)
         self.delegate?.deleteRow(atIndex: index)
        //tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
}
