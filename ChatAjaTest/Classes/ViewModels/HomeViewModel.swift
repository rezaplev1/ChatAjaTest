//
//  HomeViewModel.swift
//  ChatAjaTest
//
//  Created by Muhammad Nizar on 09/11/19.
//  Copyright © 2019 Muhammad Nizar. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import FirebaseFirestore

protocol HomeViewModelDelegate : class {
    func showLoading()
    func hideLoading()
    func didGetAllChatListSuccess(chats:[Chat])
    func didGetAllChatListError(message: String)
    func insertRow(atIndex index:Int)
    func updateRow(atIndex index:Int)
    func deleteRow(atIndex index:Int)
}

class HomeViewModel {
    
    weak var delegate: HomeViewModelDelegate?
    private let db = Firestore.firestore()
    
    private var chatReference: CollectionReference {
        return db.collection("chats")
    }
    
    private var chatListener: ListenerRegistration?
    var chats = [Chat]()
    
    func observerChatListener() {
        
        let currentUser = Defaults[.currentUser]
        chatListener = chatReference.whereField("userIDs", arrayContains: currentUser?.userId ?? "").addSnapshotListener { querySnapshot, error in
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
        guard let chat = Chat(document: change.document) else {
            return
        }
        
        switch change.type {
        case .added:
            addChatToTable(chat)
            
        case .modified:
            updateChatInTable(chat)
            
        case .removed:
            removeChatFromTable(chat)
        }
    }
    
    private func addChatToTable(_ chat: Chat) {
        guard !chats.contains(chat) else {
            return
        }
        
        chats.append(chat)
        chats.sort()
        
        guard let index = chats.firstIndex(of: chat) else {
            return
        }
        print("index addChatToTable :\(index)")
        self.delegate?.insertRow(atIndex: index)
        // tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        
    }
    
    private func updateChatInTable(_ chat: Chat) {
        guard let index = chats.firstIndex(of: chat) else {
            return
        }
        
        chats[index] = chat
        self.delegate?.updateRow(atIndex: index)
        //tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func removeChatFromTable(_ chat: Chat) {
        guard let index = chats.firstIndex(of: chat) else {
            return
        }
        
        chats.remove(at: index)
         self.delegate?.deleteRow(atIndex: index)
        //tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
}
