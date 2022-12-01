//
//  ChatViewController.swift
//  Simple Messenger
//
//  Created by Дмитрий Никольский on 01.12.2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController {
    
    var chatId: String?
    var otherId: String?
    let service = Service.shared
    let selfSender = Sender(senderId: "1", displayName: "")
    let otherSender = Sender(senderId: "2", displayName: "")
    
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        showMessageTimestampOnSwipeLeft = true
        messageInputBar.delegate = self
        
        
        if chatId == nil {
            service.getConversationId(otherId:  otherId!) { [weak self] chatId in
                self?.chatId = chatId
                self?.getMessages(conversationId: chatId)

            }
        }
    }
    
    func getMessages(conversationId: String) {
        service.getAllMessages(chatId: conversationId) { [weak self] messages in
            self?.messages = messages
            self?.messagesCollectionView.reloadDataAndKeepOffset()
            
        }
    }
    
    
    
}


extension ChatViewController: MessagesDisplayDelegate, MessagesLayoutDelegate, MessagesDataSource  {
    func currentSender() -> SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
}

extension ChatViewController : InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        
        let message = Message(sender: selfSender, messageId:  "", sentDate: Date(), kind: .text(text))
        messages.append(message)
        service.sendMessage(otherId: self.otherId, conversationId: self.chatId, text: text) { [weak self] conversationId in
            DispatchQueue.main.async {
                inputBar.inputTextView.text  = nil
                self?.messagesCollectionView.reloadDataAndKeepOffset()
            }
            self?.chatId = conversationId
        }
    }
}
