//
//  ChatMessage.swift
//  ChatAppiOS
//
//  Created by Vasu-Macbook-Pro  on 20/06/24.
//

import Foundation

struct ChatMessage {
    let message: String
    let messageType: MessageType
    let senderId: String
}

func chatMessageToDictionary(message: ChatMessage) -> [String: Any] {
  return [
    "message": message.message,
    "messageType": message.messageType.rawValue,
    "senderId": message.senderId
  ]
}
