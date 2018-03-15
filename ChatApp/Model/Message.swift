//
//  Message.swift
//  ChatApp
//
//  Created by Aboubakrine Niane on 07/03/2018.
//  Copyright © 2018 Aboubakrine Niane. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
struct Message {
    var content : String?
    var senderUid : String!
    var receiverUid : String!
    var time : TimeInterval!
    
    
    func getChatPartenerUid() -> String{
        return receiverUid == Auth.auth().currentUser?.uid ? senderUid : receiverUid
    }
}
