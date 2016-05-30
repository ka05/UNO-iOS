//
//  ChallengeTableCell.swift
//  uno
//
//  Created by Clayton Herendeen on 1/7/16.
//  Copyright © 2016 Clayton Herendeen. All rights reserved.
//

import UIKit

class ChallengeTableCell: UITableViewCell {
    
    @IBOutlet weak var statusIndicator: UIView!
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var challengeText: UIButton!
    var challengeId:String = ""
    var vc:UIViewController = UIViewController()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func challengeTapped(sender: AnyObject) {
        
    }

    @IBAction func startGameTapped(sender: AnyObject) {
        UNOUtil.currChallengeId = challengeId
        UNOUtil.startGame(UNOUtil.lobbyVC!)
    }
}
