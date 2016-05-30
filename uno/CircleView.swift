//
//  CircleView.swift
//  uno
//
//  Created by Clayton Herendeen on 1/23/16.
//  Copyright © 2016 Clayton Herendeen. All rights reserved.
//

import UIKit

class CircleView: UIView {

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        self.layer.cornerRadius = self.layer.bounds.height / 2
        self.layer.masksToBounds = true
        self.layer.backgroundColor = UIColorFromHex(0xffb94d, alpha:1.0).CGColor
    }
}
