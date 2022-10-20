//
//  BusinessRestaurantManageLocationTableViewCell.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 31.01.2021.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class BusinessRestaurantManageLocationTableViewCell: UITableViewCell {

	@IBOutlet var street: UILabel!
	@IBOutlet var cityAndPostal: UILabel!
	@IBOutlet var editButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    
	var index = -1
	var superVc : BusinessRestaurantEditManageLocationsViewController!
	
	@IBAction func editTapped(_ sender: Any) {
		superVc.updateLocation(index: self.index)
	}
    @IBAction func deleteTapped(_ sender: Any) {
        print("Index..\(self.index)..\(superVc)")
        
        superVc.deleteLocation(index: self.index)
    }
	
}
