//
//  RestaurantDetailMediaImagesCollectionViewCell.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 21.01.2021.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class RestaurantDetailMediaImagesCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet var img: UIImageView!
	
	var delegate : BusinessEditDelegate!
	
	@IBAction func editTapped(_ sender: Any) {
		self.delegate.imagePhotoEditTapped()
	}
	
}
