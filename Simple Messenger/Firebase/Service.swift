//
//  Service.swift
//  Simple Messenger
//
//  Created by Дмитрий Никольский on 30.11.2022.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore


class Service {
    static let shared = Service()
    init(){}
    
    func createNewUser(_ data: LoginField, completion: @escaping (AuthResponse)->()) {
        Auth.auth().createUser(withEmail: data.email , password: data.password) { result, error in
            if error == nil {
                if result != nil {
                    let userId = result?.user.uid
                    let email = data.email
                    let data: [String:Any] = ["email":email]
                    Firestore.firestore().collection("users").document(userId!).setData(data)
                    
                    completion(.succses)
                }
            } else {
                completion(.error)
            }
        }
    }
    
    func confirmEmail() {
        Auth.auth().currentUser?.sendEmailVerification(completion: { error in
            if error != nil {
                print(error?.localizedDescription as Any)
            }
        })
    }
    
    func authInApp(_ data: LoginField, completion: @escaping (AuthResponse)->()){
        Auth.auth().signIn(withEmail: data.email, password: data.password) { result, error in
            if error != nil {
                completion(.error)
            } else {
                if let result = result {
                    if result.user.isEmailVerified {
                        completion(.succses)
                    } else {
                        self.confirmEmail()
                        completion(.notVerified)
                    }
                }
            }
        }
    }
    
    func getAllUsers(completion: @escaping  ([CurrentUser]) -> ()){
       
        guard let email = Auth.auth().currentUser?.email else {return}
        
        var currentUsers = [CurrentUser]()
        Firestore.firestore().collection("users")
            .whereField("email", isNotEqualTo: email)
            .getDocuments  { snapshot, error in
            if error == nil {
                var emailList = [String]()
                if let documents = snapshot?.documents{
                    for document in documents {
                        let data = document.data()
                        let userId = document.documentID
                        let email = data["email"] as! String
                        emailList.append(email)
                        
                        currentUsers.append(CurrentUser(id: userId, email: email))
                    }
                }
                completion(currentUsers)
            }
        }
        
    }
    
    
    //MARK: -- Messenger
    
    func sendMessage(otherId: String?, conversationId: String?, text: String, completion: @escaping (String)->()){
        if let uid = Auth.auth().currentUser?.uid {
            if conversationId == nil {
                
                let conversationId = UUID().uuidString
                
                let selfData: [String:Any] = [
                    "date": Date(),
                    "otherId": otherId!
                ]
                
                let otherData: [String:Any] = [
                    "date": Date(),
                    "otherId": uid
                    ]
                
                // наша переписка с Х
                Firestore.firestore().collection("users")
                    .document(uid)
                    .collection("conversations")
                    .document(conversationId)
                    .setData(selfData)
                
                // переписка Х с нами
                Firestore.firestore().collection("users")
                    .document(otherId!)
                    .collection("conversations")
                    .document(conversationId)
                    .setData(otherData)
               
                let message: [String:Any] = [
                    "date": Date(),
                    "sender": uid,
                    "text": text
                    ]
                
                let conversationInfo: [String: Any] = [
                    "date": Date(),
                    "sender": uid,
                    "text": text
                    ]
                Firestore.firestore().collection("conversations")
                    .document(conversationId)
                    .setData(conversationInfo) { error in
                        if let error = error{
                            print(error.localizedDescription)
                            return
                        }
                        Firestore.firestore().collection("conversations")
                            .document(conversationId)
                            .collection("messages")
                            .addDocument(data: message) {error in
                                if error == nil {
                                    completion(conversationId)
                                }
                            }
                            
                    }
                    
                
            } else {
                let message: [String:Any] = [
                    "date": Date(),
                    "sender": uid,
                    "text": text
                ]
                Firestore.firestore().collection("conversations").document(conversationId!).collection("messages").addDocument(data: message) { error in
                    if error == nil {
                        completion(conversationId!)
                    }
                    
                }
                
            }
            
        }
    }
    
    func updateConversation(){
        
    }
    
    func getConversationId(otherId: String, completion: @escaping(String)->()){
        if let uid = Auth.auth().currentUser?.uid{
            
            Firestore.firestore().collection("users")
                .document(uid)
                .collection("conversations")
                .whereField("otherId", isEqualTo: otherId)
                .getDocuments { snapshot, error in
                    if let error = error {
                        return
                    }
                    if let snapshot = snapshot, !snapshot.documents.isEmpty {
                        let document = snapshot.documents.first
                        if let conversationId = document?.documentID{
                            completion(conversationId)
                        }
                    }
                }
        }
    }
    
    func getAllMessages(chatId: String, completion: @escaping ([Message]) -> ()){
        if let uid = Auth.auth().currentUser?.uid {
            Firestore.firestore().collection("conversations")
                .document(chatId)
                .collection("messages")
                .limit(to: 50)
                .order(by: "date", descending: false)
                .addSnapshotListener { snapshot, error in
                    if error != nil {
                        return
                    }
                    if let snapshot = snapshot,  !snapshot.documents.isEmpty{
                        var messages = [Message]()
                        var sender = Sender(senderId: uid, displayName: "")
                        for document in snapshot.documents {
                            let data = document.data()
                            let userId = data["sender"] as! String
                            
                            let messageId = document.documentID
                            let date = data["date"] as! Timestamp
                            let sentDate = date.dateValue()
                            let text = data["text"] as! String
                            
                            if userId == uid {
                                sender = Sender(senderId: "1", displayName: "")
                            } else {
                                sender = Sender(senderId: "2", displayName: "")
                            }
                            
                            messages.append(Message(sender: sender, messageId: messageId, sentDate: sentDate, kind: .text(text)))
                        }
                        completion(messages)
                    }
                }
        }
    }
    
    func getOneMessage(){
         
    }
}
