//
//  HoneyspottersTableViewCell.swift
//  HoneySpot
//
//  Created by htcuser on 10/11/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class HoneyspottersTableViewCell: UITableViewCell {

    @IBOutlet weak var honeySpotterFullName: UILabel!
    @IBOutlet weak var honeySpotterName: UILabel!
    @IBOutlet weak var honeySpotterImage: UIImageView!
    @IBOutlet weak var messageButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
