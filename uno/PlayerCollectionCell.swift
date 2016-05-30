//
//  PlayerCollectionCell.swift
//  uno
//
//  Created by Clayton Herendeen on 1/9/16.
//  Copyright © 2016 Clayton Herendeen. All rights reserved.
//

import UIKit

class PlayerCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var saidUnoLabel: UILabel!
    @IBOutlet weak var cardCountLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userIcon: UIImageView!
 
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        // round edges on username label
        usernameLabel.layer.cornerRadius = 3
        usernameLabel.layer.masksToBounds = true
        
        //round image
        userIcon.layer.cornerRadius = userIcon.frame.size.height / 2
        userIcon.layer.masksToBounds = true
        
    }
}
