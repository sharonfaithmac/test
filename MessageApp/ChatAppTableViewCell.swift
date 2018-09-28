//
//  ChatAppTableViewCell.swift
//  MessageApp
//
//  Created by Sharon  Macasaol on 9/28/18.
//  Copyright © 2018 Sharon  Macasaol. All rights reserved.
//

import UIKit

class ChatAppTableViewCell: UITableViewCell {
    
    @IBOutlet weak var messageLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
