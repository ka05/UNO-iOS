//
//  CurrUser.swift
//  uno
//
//  Created by Clayton Herendeen on 12/27/15.
//  Copyright © 2015 Clayton Herendeen. All rights reserved.
//

import UIKit

class CurrUser: NSObject {
    static let sharedInstance = CurrUser()

    var username:String = ""
    var uid:String = ""
    
    func getUsername() -> String{
        return self.username
    }
    
    func getUid() -> String{
        return self.uid
    }
    
    
}
