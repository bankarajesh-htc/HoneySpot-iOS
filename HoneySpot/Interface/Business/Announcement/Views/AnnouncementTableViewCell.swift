//
//  AnnouncementTableViewCell.swift
//  HoneySpot
//
//  Created by htcuser on 01/10/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class AnnouncementTableViewCell: UITableViewCell {

    
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var mainDescription: UILabel!
    @IBOutlet weak var subDescription: UILabel!
    
    @IBOutlet weak var userImage1: UIImageView!
    @IBOutlet weak var userImage2: UIImageView!
    @IBOutlet weak var userImage3: UIImageView!
    @IBOutlet weak var userImage4: UIImageView!
    @IBOutlet weak var userImage5: UIImageView!
    @IBOutlet weak var reachCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
