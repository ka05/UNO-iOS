//
//  Challenge.swift
//  uno
//
//  Created by Clayton Herendeen on 1/7/16.
//  Copyright © 2016 Clayton Herendeen. All rights reserved.
//

import Foundation
import SwiftyJSON

class Challenge{
    
    var id:String = ""
    var challenger:String = ""
    var usersChallenged:[String] = []
    var timestamp:String = ""
    var status:String = ""
    var displayText = ""
    
    init(challenge:JSON){
        id = challenge["id"].stringValue
        challenger = challenge["challenger"]["username"].stringValue
        usersChallenged = UNOUtil.buildUsersChallengedArray(challenge["usersChallenged"])
        timestamp = challenge["timestamp"].stringValue
        status = challenge["status"].stringValue
        
        if(challenger == CurrUser.sharedInstance.username){
            displayText = "You challenged " + usersChallenged.joinWithSeparator(", ") + " (" + status + ")"
        }else{
            displayText = "Challenge from " + challenger + " (" + status + ")"
        }
        
    }
}