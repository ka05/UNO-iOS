//
//  CardCollectionCell.swift
//  uno
//
//  Created by Clayton Herendeen on 1/9/16.
//  Copyright © 2016 Clayton Herendeen. All rights reserved.
//

import UIKit

class CardCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var cardImage: UIImageView!
    
    var card:Card?
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("cardTapped:"))
        cardImage.userInteractionEnabled = true
        cardImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func cardTapped(img: AnyObject){
        UNOUtil.playCard(card!)
    }
}
