//
//  RestaurantDetailGeneralTableViewCell.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 20.01.2021.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class RestaurantDetailGeneralTableViewCell: UITableViewCell {

	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var descriptionLabel: UILabel!
	var superVc : BusinessRestaurantEditViewController!
	
	func prepareCell(model : SpotModel){
		nameLabel.text = model.name
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = "\(model.spotDescription.replace(string: "\\n", replacement: "\n"))"
	}
	
	@IBAction func editTapped(_ sender: Any) {
		self.superVc.editUpdateGeneralInfoTapped()
	}
	
}
