//
//  chatMsgTableCell.swift
//  uno
//
//  Created by Clayton Herendeen on 12/27/15.
//  Copyright © 2015 Clayton Herendeen. All rights reserved.
//

import UIKit

class ChatMsgTableCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        layer.sublayers![0].borderWidth = 0.5
        layer.sublayers![0].cornerRadius = 3.0
        layer.sublayers![0].borderColor = UIColor.grayColor().CGColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
