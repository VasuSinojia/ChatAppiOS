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

func dictionaryToChatMessage(dictionary: [String: Any]) -> ChatMessage {
    let message = dictionary["message"] as? String
    let messageTypeRawValue = dictionary["messageType"] as? String
    let messageType = MessageType(rawValue: messageTypeRawValue ?? "")
    let senderId = dictionary["senderId"] as? String
    return ChatMessage(message: message ?? "", messageType: messageType ?? .TEXT, senderId: senderId ?? "")
}
