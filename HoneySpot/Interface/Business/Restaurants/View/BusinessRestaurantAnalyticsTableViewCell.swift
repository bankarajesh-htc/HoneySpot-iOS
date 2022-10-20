//
//  BusinessRestaurantAnalyticsTableViewCell.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 3.10.2020.
//  Copyright © 2020 HoneySpot. All rights reserved.
//

import UIKit

class BusinessRestaurantAnalyticsTableViewCell: UITableViewCell {

	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var chartView: UIView!
	@IBOutlet var emptyView: UIView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
