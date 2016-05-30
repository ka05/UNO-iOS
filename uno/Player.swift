//
//  Player.swift
//  uno
//
//  Created by Clayton Herendeen on 1/9/16.
//  Copyright © 2016 Clayton Herendeen. All rights reserved.
//

import Foundation
import SwiftyJSON

class Player{
    
    var username:String = ""
    var id:String = ""
    var inGame:Bool = false
    var cardCount:String = ""
    var calledUno:Bool = false
    var isMyTurn:Bool = false
    var hand:[Card] = []
    
    func initPlayerData(player:JSON){
        username = player["username"].stringValue
        id = player["id"].stringValue
        inGame = player["inGame"].boolValue
        calledUno = player["calledUno"].boolValue
        isMyTurn = player["isMyTurn"].boolValue
        cardCount = player["cardCount"].stringValue
        
        for (index, element) in player["hand"].enumerate(){
            hand.append(Card( card: player["hand"][index] ))
        }

    }
}