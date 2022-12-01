//
//  MessageType.swift
//  Simple Messenger
//
//  Created by Дмитрий Никольский on 01.12.2022.
//

import Foundation
import MessageKit

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
    
}
