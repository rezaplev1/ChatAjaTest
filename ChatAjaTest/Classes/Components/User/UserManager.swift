//
//  UserManager.swift
//  ChatAjaTest
//
//  Created by Muhammad Nizar on 11/11/19.
//  Copyright © 2019 Muhammad Nizar. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore

class UserManager {
    
    func currentUserID() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    func login(email:String, password:String, success: @escaping (_ currentUser: User)->(), failure: @escaping (_ messageError:String)->()) {
        Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
            if error == nil {
                if let user = self.getCurrentUser() {
                    success(user)
                    return
                }
            }
            failure(error?.localizedDescription ?? "Ooops, something went wrong" )
        }
    }
    
    func getUser(withUserId userId:String, completion: @escaping (_ currentUser: UserModel)->()) {
        
        let db = Firestore.firestore()
        let collectionReference = db.collection("users")
        collectionReference.whereField("userId", isEqualTo: userId)
        .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    let documents = querySnapshot!.documents
                    if let userDocument = documents.first {
                        if let currentUser = UserModel(document: userDocument) {
                            completion(currentUser)
                        }
                    }
                }
        }
    }
    
    @discardableResult func logout() -> Bool {
        do {
            try Auth.auth().signOut()
            SceneDelegate.sharedSceneDelegate()?.setRootLoginPage()
            return true
        } catch {
            return false
        }
    }
}
