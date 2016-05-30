//
//  EmobaFunctions.swift
//  Emoba
//
//  Created by Scott Terry on 10/8/15.
//  Copyright © 2015 Envative. All rights reserved.
//

import Foundation
import UIKit

// For any hex code 0xXXXXXX and alpha value,
// return a matching UIColor
public func UIColorFromHex(rgbValue:UInt32, alpha:Double) -> UIColor {
    let red = CGFloat((rgbValue & 0xFF0000) >> 16)/255.0
    let green = CGFloat((rgbValue & 0xFF00) >> 8)/255.0
    let blue = CGFloat(rgbValue & 0xFF)/255.0
    
    return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
}
public func UIColorFromHex(hexString:String, alpha:Double) -> UIColor {
    let scanner = NSScanner(string: hexString)
    scanner.charactersToBeSkipped = NSCharacterSet(charactersInString: "#")
    var rgbValue:UInt32 = 0
    scanner.scanHexInt(&rgbValue)
    
    let red = CGFloat((rgbValue & 0xFF0000) >> 16)/255.0
    let green = CGFloat((rgbValue & 0xFF00) >> 8)/255.0
    let blue = CGFloat(rgbValue & 0xFF)/255.0
    
    return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
}

public func HexFromUIColor(color: UIColor) -> String {
    var r:CGFloat = 0
    var g:CGFloat = 0
    var b:CGFloat = 0
    var a:CGFloat = 0
    
    color.getRed(&r, green: &g, blue: &b, alpha: &a)
    
    let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
    
    return String(format:"#%06x", rgb)
}

public func RGBFromUIColor(color: UIColor) -> String {
    var r:CGFloat = 0
    var g:CGFloat = 0
    var b:CGFloat = 0
    var a:CGFloat = 0
    
    color.getRed(&r, green: &g, blue: &b, alpha: &a)
    
    return String(format:"rgba(%d,%d,%d)", arguments:[Int(r*255),Int(g*255),Int(b*255)])
}

public func RGBAFromUIColor(color: UIColor, opacity: CGFloat) -> String {
    var r:CGFloat = 0
    var g:CGFloat = 0
    var b:CGFloat = 0
    var a:CGFloat = 0
    
    color.getRed(&r, green: &g, blue: &b, alpha: &a)
    
    return String(format:"rgba(%d,%d,%d,%.03f)", arguments:[Int(r*255),Int(g*255),Int(b*255),opacity])
}

func jsonStringify(jsonObject: AnyObject) -> String {
    var jsonString: String = ""
    
    switch jsonObject {
    case _ as [String: AnyObject] :
        let tempObject: [String: AnyObject] = jsonObject as! [String: AnyObject]
        jsonString += "{"
        for (key , value) in tempObject {
            if jsonString.characters.count > 1 {
                jsonString += ","
            }
            jsonString += "\"" + String(key) + "\":"
            jsonString += jsonStringify(value)
        }
        jsonString += "}"
        
    case _ as [AnyObject] :
        jsonString += "["
        for i in 0..<jsonObject.count {
            if i > 0 {
                jsonString += ","
            }
            jsonString += jsonStringify(jsonObject[i])
        }
        jsonString += "]"
        
    case _ as String :
        jsonString += ("\"" + String(jsonObject) + "\"")
    case _ as NSNumber :
        if jsonObject.isEqualToValue(NSNumber(bool: true)) {
            jsonString += "true"
        } else if jsonObject.isEqualToValue(NSNumber(bool: false)) {
            jsonString += "false"
        } else {
            return String(jsonObject)
        }
    case _ as NilLiteralConvertible :
        jsonString += "null"
        
    default :
        jsonString += ""
    }
    return jsonString
}
