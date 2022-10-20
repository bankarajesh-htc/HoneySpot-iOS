//
//  RestaurantDetailContactInfoTableViewCell.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 20.01.2021.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class RestaurantDetailContactInfoTableViewCell: UITableViewCell {

	@IBOutlet var websiteLabel: UILabel!
	@IBOutlet var phoneLabel: UILabel!
	@IBOutlet var emailLabel: UILabel!
    @IBOutlet weak var noDataLabel: UILabel!
	
	var superVc : BusinessRestaurantEditViewController!
	
	func prepareCell(model : SpotModel){
		if(model.website == "" && model.phoneNumber == ""  && model.email == "") {
            noDataLabel.isHidden = false
            websiteLabel.isHidden = true
            phoneLabel.isHidden = true
            emailLabel.isHidden = true
            
            
		}else{
            noDataLabel.isHidden = true
            websiteLabel.isHidden = false
            phoneLabel.isHidden = false
            emailLabel.isHidden = false
            
            if(model.website == "" || model.website == nil )
            {
                websiteLabel.text = "Not Available"
            }
            else
            {
                websiteLabel.text = model.website
            }
            if(model.phoneNumber == ""){
                phoneLabel.text = "Not Available"
            }else{
                phoneLabel.text = model.phoneNumber
            }
            
            if(model.email == "" || model.email == nil){
                emailLabel.text = "Not Available"
            }else{
                emailLabel.text = model.email
            }
		}
		
		
	}
	
	
	@IBAction func editTapped(_ sender: Any) {
		self.superVc.editUpdateContactTapped()
	}
	
}
