//
//  RestaurantDetailVisibilityTableViewCell.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 20.01.2021.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class RestaurantDetailVisibilityTableViewCell: UITableViewCell {

	@IBOutlet var img: UIImageView!
	@IBOutlet var visibilityLabel: UILabel!
	
	var superVc : BusinessRestaurantEditViewController!
	
	func prepareCell(model : SpotModel){
		
	}
	
	@IBAction func editTapped(_ sender: Any) {
		
	}
}
