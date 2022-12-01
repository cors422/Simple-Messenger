//
//  SenderType.swift
//  Simple Messenger
//
//  Created by Дмитрий Никольский on 01.12.2022.
//

import Foundation
import MessageKit

struct Sender: SenderType {
    var senderId: String
    var displayName: String
    
}
