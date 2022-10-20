//
//  BusinessSettingsTableViewCell.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 30.06.2020.
//  Copyright © 2020 HoneySpot. All rights reserved.
//

import UIKit

class BusinessSettingsTableViewCell: UITableViewCell {

	@IBOutlet var img: UIImageView!
	@IBOutlet var titleLabel: UILabel!
    @IBOutlet var upgradeButton: UIButton!
    var delegate : BusinessSubscriptionDelegate!
    @IBAction func didClickUpgrade(_ sender: UIButton) {
        
        self.delegate.navigateToSubscriptionPage()
    }
	
}
