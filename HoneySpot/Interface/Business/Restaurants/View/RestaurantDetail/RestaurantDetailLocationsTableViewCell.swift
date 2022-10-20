//
//  RestaurantDetailLocationsTableViewCell.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 20.01.2021.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class RestaurantDetailLocationsTableViewCell: UITableViewCell {

	@IBOutlet var locationLabel: UILabel!
    @IBOutlet var viewAllLocationButton: UIButton!
    
    @IBOutlet var viewAllLocationButtonHeight: NSLayoutConstraint!
    @IBOutlet var viewAllLocationButtonTop: NSLayoutConstraint!
	var superVc : BusinessRestaurantEditViewController!
	
	func prepareCell(model : SpotModel){
		locationLabel.text = model.address
        
        if model.otherlocations.count >= 1 {
            viewAllLocationButton.isHidden =  false
            viewAllLocationButtonHeight.constant = 22
            viewAllLocationButtonTop.constant = 10
        }
        else
        {
            viewAllLocationButtonHeight.constant = 0
            viewAllLocationButtonTop.constant = 0
            viewAllLocationButton.isHidden =  true
        }
	}
	
	@IBAction func editTapped(_ sender: Any) {
		self.superVc.editLocations()
	}
	
	@IBAction func viewAllTapped(_ sender: Any) {
		self.superVc.editLocations()
	}
	
}
