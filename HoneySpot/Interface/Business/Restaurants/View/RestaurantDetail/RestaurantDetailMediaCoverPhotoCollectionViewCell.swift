//
//  RestaurantDetailMediaCoverPhotoCollectionViewCell.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 21.01.2021.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class RestaurantDetailMediaCoverPhotoCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet var img: UIImageView!
    @IBOutlet weak var noDataLabel: UILabel!
	
	var delegate : BusinessEditDelegate!
	
	@IBAction func editTapped(_ sender: Any) {
		self.delegate.coverPhotoEditTapped()
	}
	
}
