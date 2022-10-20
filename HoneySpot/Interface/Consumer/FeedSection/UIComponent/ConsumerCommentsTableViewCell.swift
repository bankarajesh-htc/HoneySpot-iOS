//
//  ConsumerCommentsTableViewCell.swift
//  HoneySpot
//
//  Created by htcuser on 18/11/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class ConsumerCommentsTableViewCell: UITableViewCell {

    @IBOutlet var userImage: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var seperatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
