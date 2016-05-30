//
//  OnlineUsersTableCell.swift
//  uno
//
//  Created by Clayton Herendeen on 12/30/15.
//  Copyright © 2015 Clayton Herendeen. All rights reserved.
//

import UIKit

class OnlineUserTableCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var inGameIndicator: UIView!
    var uid:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
