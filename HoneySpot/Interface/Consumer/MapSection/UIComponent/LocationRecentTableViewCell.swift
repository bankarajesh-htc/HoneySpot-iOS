//
//  LocationRecentTableViewCell.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 13.11.2019.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit

class LocationRecentTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
