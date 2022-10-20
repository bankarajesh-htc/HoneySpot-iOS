//
//  BusinessRestaurantTableViewCell.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 30.06.2020.
//  Copyright © 2020 HoneySpot. All rights reserved.
//

import UIKit

class BusinessRestaurantTableViewCell: UITableViewCell {

	
	@IBOutlet var img: UIImageView!
	@IBOutlet var name: UILabel!
	@IBOutlet var subtitle: UILabel!
	@IBOutlet var editButton: UIButton!
	@IBOutlet var analyticsButton: UIButton!
	@IBOutlet var reviewLabel: UILabel!
	
	var spotModel : SpotModel!
	var superVc : BusinessRestaurantViewController!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	@IBAction func editTapped(_ sender: Any) {
		self.superVc.editTapped(spotModel : self.spotModel)
	}
	
	@IBAction func analyticsTapped(_ sender: Any) {
		self.superVc.analyticsTapped(spotModel : self.spotModel)
	}
	
}
