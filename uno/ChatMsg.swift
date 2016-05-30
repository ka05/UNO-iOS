//
//  ChatMsg.swift
//  uno
//
//  Created by Clayton Herendeen on 2/20/16.
//  Copyright © 2016 Clayton Herendeen. All rights reserved.
//

import Foundation
import SwiftyJSON

class ChatMsg: NSObject {

    var sender:String = ""
    var message:String = ""
    var timestamp:String = ""
    
    init(chatMsg:JSON){
        sender = chatMsg["sender"].stringValue
        message = chatMsg["message"].stringValue
        print(chatMsg["timestamp"].stringValue)
        timestamp = UNOUtil.formatTime(chatMsg["timestamp"].stringValue)
    }
    
}
