//
//  ChatViewController.swift
//  ChatAppiOS
//
//  Created by Vasu-MacMini-M1 on 10/07/23.
//

import UIKit
import MessageKit
import InputBarAccessoryView

struct Message: MessageType {
    var sender: MessageKit.SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKit.MessageKind
}

struct Sender: SenderType {
    var photoURL: String
    var senderId: String
    var displayName: String
}

class ChatViewController: MessagesViewController {
    
    public static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
    
    var titleVC: String = ""
    private var isNewConversation = true
    var otherUserEmail: String = ""
    
    private var messages: [Message] = []
    
    private var selfSender: Sender = {
        let currentUserEmail = UserDefaults.standard.string(forKey: "email") ?? ""
        let sender = Sender(photoURL: "", senderId: currentUserEmail, displayName: "Vasu")
        return sender
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Hello World Message")))
        
        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Hello World Message, Hello World Message, Hello World Message")))
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnClicked(_ sender: Any) {
        
    }
    
    private func initView() {
        self.title = titleVC
        print("other user email \(self.otherUserEmail)")
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty else { return }
        
        //Send Message
        
        if isNewConversation {
            // Add entry to database
            let messageId = createMessageId()
            let message = Message(sender: selfSender, messageId: messageId ?? "", sentDate: Date(), kind: .text(text))
//            DatabaseManager.sharedInstance.createNewConversation(with: otherUserEmail, firstMessage: message, completionHandler: { success in
//                print("created new conversation \(success)")
//                if success {
//                    print("message sent")
//                } else {
//                    print("message faied to send")
//                }
//            })
            
        } else {
            // Continue messaging
            
        }
        
    }
    
    private func createMessageId() -> String? {
        guard let currentUserEmail = UserDefaults.standard.string(forKey: "email") else {
            return nil
        }
        
        let dateString = Self.dateFormatter.string(from: Date())
        let newIdentifier = "\(otherUserEmail)_\(currentUserEmail)_\(dateString)"
        print("Created message id: \(newIdentifier)")
        return newIdentifier
    }
    
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> MessageKit.SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
    
}
