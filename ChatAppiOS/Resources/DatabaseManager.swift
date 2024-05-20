//
//  DatabaseManager.swift
//  ChatAppiOS
//
//  Created by Vasu-MacMini-M1 on 07/07/23.
//

import Foundation
import FirebaseDatabase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class DatabaseManager {
    
    static let sharedInstance = DatabaseManager()
    
//    private let database = FirebaseDatabase.Database.database().reference()
    private let firestoreDB = Firestore.firestore()
}

//MARK: - User
extension DatabaseManager {
    public func insertUser(user: UserModel, completionHandler: @escaping (Bool) -> Void) {
//        firestoreDB.collection(Constants.sharedInstance.KEY_COLLECTION_USER).addDocument(data: user.convertUserModelToDictionary(user: user),completion: { err in
//            if let _ = err {
//                completionHandler(false)
//            } else {
//                completionHandler(true)
//            }
//        })
    }
    
    public func deleteUser() {
        
    }
    
    public func getAllUsers(completionHandler: @escaping ([UserModel]) -> Void) {
        firestoreDB.collection(Constants.sharedInstance.KEY_COLLECTION_USER).getDocuments { (snapshot, error) in
            if error != nil { return }
            var userList: [UserModel] = []
            if let users = snapshot?.documents {
                for user in users {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: user.data())
                        let userModel = try? JSONDecoder().decode(UserModel.self, from: data)
                        if let userModel = userModel {
                            if userModel.userId != Auth.auth().currentUser?.uid {
                                userList.append(userModel)
                            }
                        }
                    } catch {
                        
                    }
                }
                completionHandler(userList)
            }
        }
    }
    
    public func getUser(uid: String, completion: @escaping (UserModel) -> Void) {
        let collectionRef = firestoreDB.collection(Constants.sharedInstance.KEY_COLLECTION_USER)
        collectionRef.whereField("userId", isEqualTo: uid).getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting document: \(err)")
            } else if (snapshot?.isEmpty)! {
                print("Error snapshot is empty")
            } else {
                for document in (snapshot?.documents)! {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: document.data())
                        let userModel = try? JSONDecoder().decode(UserModel.self, from: data)
                        completion(userModel!)
                    } catch {
                        
                    }
                }
            }
        }
    }
}

extension DatabaseManager {
    public func checkAndCreateNewConversation(conversationId: String,completionHandler: @escaping () -> Void) {
        firestoreDB.collection(Constants.sharedInstance.KEY_COLLECTION_CONVERSATIONS).getDocuments { snapshot, error in
            if let documents = snapshot?.documents {
                let documentFound = documents.contains { $0.documentID == conversationId }
                if !documentFound {
                    self.firestoreDB.collection(Constants.sharedInstance.KEY_COLLECTION_CONVERSATIONS).document(conversationId).setData(["message" : "Hi"])
                }
                completionHandler()
            }
        }
    }
}
