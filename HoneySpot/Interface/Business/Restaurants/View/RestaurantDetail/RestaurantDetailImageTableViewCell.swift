//
//  RestaurantDetailImageTableViewCell.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 20.01.2021.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class RestaurantDetailImageTableViewCell: UITableViewCell {

	@IBOutlet var img: UIImageView!
	@IBOutlet var name: UILabel!
	
	func prepareCell(model : SpotModel){
		img.kf.setImage(with: URL(string: model.photoUrl))
		name.text = model.name
	}
	
}
