//
//  LocationTableViewCell.swift
//  HoneySpot
//
//  Created by Chandramouli on 22/12/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet var locationName: UILabel!
    @IBOutlet var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
