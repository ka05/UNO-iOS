//
//  CircleLabel.swift
//  uno
//
//  Created by Clayton Herendeen on 1/24/16.
//  Copyright © 2016 Clayton Herendeen. All rights reserved.
//

import UIKit

class CircleLabel: UILabel {
        
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        self.layer.cornerRadius = self.layer.bounds.height / 2
        self.layer.masksToBounds = true
    }

}
