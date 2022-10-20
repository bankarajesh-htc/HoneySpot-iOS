//
//  SelectRestaurantClaimTableViewCell.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 2.03.2021.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class SelectRestaurantClaimTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var claimButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
