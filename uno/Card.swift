//
//  Card.swift
//  uno
//
//  Created by Clayton Herendeen on 1/9/16.
//  Copyright © 2016 Clayton Herendeen. All rights reserved.
//

import Foundation
import SwiftyJSON

class Card{
    
    var svgName:String = ""
    var cardName:String = ""
    var value:String = ""
    var color:String = ""
    
    init(card:JSON){
        svgName = getSvgName(card["svgName"].stringValue, color:card["color"].stringValue)
        cardName = card["cardName"].stringValue
        value = card["value"].stringValue
        color = card["color"].stringValue
    }
    
    func getSvgName(svgName:String, color:String) ->String{
        if(svgName == "ww" || svgName == "wd"){
            if(color == "none"){
                return svgName
            }else{
                return svgName + "_" + color
            }
            
        }else{
            return svgName
        }
    }
}
