//
//  DatabaseManager.swift
//  ChatAppiOS
//
//  Created by Vasu-MacMini-M1 on 07/07/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class DatabaseManager {
    
    static let sharedInstance = DatabaseManager()
    
    private let firestoreDB = Firestore.firestore()
}

//MARK: - User
extension DatabaseManager {
    public func insertUser(user: UserModel, completionHandler: @escaping (Bool) -> Void) {
        let collectionRef = firestoreDB.collection(Constants.sharedInstance.KEY_COLLECTION_USER)
        do {
            let documentRef = try collectionRef.addDocument(from: user)
            print("Document written with ID: \(documentRef.documentID)")
            completionHandler(true)
        } catch let error {
            print("Error adding document: \(error)")
            completionHandler(false)
        }
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
    
    public func getAsyncUser(uid: String) async throws -> UserModel? {
        let collectionRef = firestoreDB.collection(Constants.sharedInstance.KEY_COLLECTION_USER)
        let documentsSnapshot = try? await collectionRef.whereField("userId", isEqualTo: uid).getDocuments()
        if !(documentsSnapshot?.isEmpty ?? true) {
            if let documents = documentsSnapshot?.documents {
                for document in documents {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: document.data())
                        let userModel = try? JSONDecoder().decode(UserModel.self, from: data)
                        return userModel ?? UserModel()
                    } catch {
                        
                    }
                }
            }
        }
        return nil
    }
}

extension DatabaseManager {
    
    func fetchMyConversations() async throws -> [UserModel] {
        let currentUserID = MyManager.user.userId ?? ""
        let conversationsRef = firestoreDB.collection(Constants.sharedInstance.KEY_COLLECTION_CONVERSATIONS)
        
        let documentsSnapshot = try await conversationsRef.whereField(Constants.sharedInstance.KEY_PARTICIPANTS, arrayContains: currentUserID).getDocuments()
        
        var conversationList : [UserModel] = []
        
        if (!documentsSnapshot.isEmpty) {
            for document in documentsSnapshot.documents {
                let data = document.data()
                let participants = data["participants"] as! [String]
                let opponent = participants.first { ele in
                    ele != currentUserID
                }
                if let opponentId = opponent {
                    let receivedUser = try? await getAsyncUser(uid: opponentId)
                    if let user = receivedUser {
                        conversationList.append(user)
                    }
                }
            }
            return conversationList
        }
        
     return conversationList
    }
    
    // Checking if conversation exists (assuming you have opponentUID)
    func getConversationId(withOpponentUID opponentUID: String, completion: @escaping (Bool, String?) -> Void) {
        let currentUserID = MyManager.user.userId ?? ""
      let conversationsRef = firestoreDB.collection(Constants.sharedInstance.KEY_COLLECTION_CONVERSATIONS)
        conversationsRef.whereField(Constants.sharedInstance.KEY_PARTICIPANTS,arrayContains: currentUserID).getDocuments { (snapshot, error) in
            if let _ = error {
                completion(false , "")
                return
            }
            
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                self.createConversations(withOpponentUID: opponentUID) { isCreated, conversationId in
                    if isCreated && !(conversationId?.isEmpty ?? true) {
                        print("Created A conversation successfully")
                        completion(true, conversationId)
                    } else {
                        print("Error createing a A conversation")
                        completion(false, "")
                    }
                }
                return
            }
            
            for document in documents {
                let participants = document.data()[Constants.sharedInstance.KEY_PARTICIPANTS] as? [String]
                if let participants = participants, participants.contains(currentUserID) && participants.contains(opponentUID) {
                    let conversationID = document.documentID
                    completion(true, conversationID)
                    return
                }
            }
            
            self.createConversations(withOpponentUID: opponentUID) { isCreated, conversationId in
                if isCreated && !(conversationId?.isEmpty ?? true) {
                    print("Created A conversation successfully")
                    completion(true, conversationId)
                } else {
                    print("Error createing a A conversation")
                    completion(false, "")
                }
            }
        }
    }
    
    // Checking if conversation exists (assuming you have opponentUID)
    func createConversations(withOpponentUID opponentUID: String, completion: @escaping (Bool, String?) -> Void) {
        let currentUserID = MyManager.user.userId ?? ""
        let conversationsRef = firestoreDB.collection(Constants.sharedInstance.KEY_COLLECTION_CONVERSATIONS).document()
        let conversationID = conversationsRef.documentID
        
        conversationsRef.setData([
            "id": conversationID,
            "participants": [currentUserID, opponentUID],
          ], completion: { (error) in
            if let _ = error {
              completion(false, "")
              return
            }
          })
        
        completion(true, conversationID)
    }
    
    func fetchChatsFromConversationId(conversationId: String) async throws -> [ChatMessage] {
        var chatMessages : [ChatMessage] = []
        var snapshot = try await firestoreDB.collection(Constants.sharedInstance.KEY_COLLECTION_CONVERSATIONS)
            .document(conversationId)
            .collection(Constants.sharedInstance.KEY_CHATS)
            .getDocuments()
        
        let documents = snapshot.documents
        if (!documents.isEmpty) {
            for document in documents {
                let message = dictionaryToChatMessage(dictionary: document.data())
                chatMessages.append(message)
            }
        }
        return chatMessages
    }
}

extension DatabaseManager {
    func sendMessage(conversationId: String, chatMessage: ChatMessage) {
        let message = chatMessageToDictionary(message: chatMessage)
        firestoreDB
            .collection(Constants.sharedInstance.KEY_COLLECTION_CONVERSATIONS)
            .document(conversationId)
            .collection(Constants.sharedInstance.KEY_CHATS)
            .addDocument(data: message)
    }
}
