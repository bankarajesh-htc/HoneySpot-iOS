//
//  LocationFilterResultTableViewCell.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 26.08.2019.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit

class LocationFilterResultTableViewCell: UITableViewCell {

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var countryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
