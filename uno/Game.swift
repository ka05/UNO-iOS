//
//  Game.swift
//  uno
//
//  Created by Clayton Herendeen on 1/9/16.
//  Copyright © 2016 Clayton Herendeen. All rights reserved.
//

import Foundation
import SwiftyJSON

class Game{
    
    var winner:String = ""
    var id:String = ""
    var allPlayersInGame:Bool = false
    var status:String = ""
    var currPlayer:Player = Player()
    var players:[Player] = []
    var discardPile:[Card] = []
    
    func initGameData(gameData:JSON){
        winner = gameData["username"].stringValue
        
        for (index, element) in gameData["players"].enumerate(){
            var player:Player = Player()
            player.initPlayerData(gameData["players"][index])
            if(player.username == CurrUser.sharedInstance.username){
                currPlayer = player
            }else{
                players.append(player)
            }
        }
        
        for (index, element) in gameData["discardPile"].enumerate(){
            discardPile.append(Card( card: gameData["discardPile"][index] ))
        }
    }
    
    /**

    {
    "winner" : "",
    "_id" : "5691a9d787849e637b376703",
    "allPlayersInGame" : false,
    "status" : "created",
    "players" : [
    {
    "username" : "beau",
    "id" : "56815c0f0a00d9381b683b30",
    "inGame" : false,
    "calledUno" : false,
    "isMyTurn" : true,
    "hand" : [
    {
    "svgName" : "y8",
    "cardName" : "Yellow 8",
    "value" : "8",
    "color" : "yellow"
    },
    {
    "svgName" : "y6",
    "cardName" : "Yellow 6",
    "value" : "6",
    "color" : "yellow"
    },
    {
    "svgName" : "b5",
    "cardName" : "Blue 5",
    "value" : "5",
    "color" : "blue"
    },
    {
    "svgName" : "yd",
    "cardName" : "Yellow Draw 2",
    "value" : "draw2",
    "color" : "yellow"
    },
    {
    "svgName" : "b5",
    "cardName" : "Blue 5",
    "value" : "5",
    "color" : "blue"
    },
    {
    "svgName" : "b2",
    "cardName" : "Blue 2",
    "value" : "2",
    "color" : "blue"
    },
    {
    "svgName" : "r8",
    "cardName" : "Red 8",
    "value" : "8",
    "color" : "red"
    }
    ]
    },
    {
    "username" : "nate",
    "id" : "563a7095b9038dc308ae8471",
    "cardCount" : 7,
    "calledUno" : false,
    "inGame" : false,
    "isMyTurn" : false
    }
    ],
    "discardPile" : [
    {
    "svgName" : "g3",
    "cardName" : "Green 3",
    "value" : "3",
    "color" : "green"
    }
    ]
    }
    
    */
}