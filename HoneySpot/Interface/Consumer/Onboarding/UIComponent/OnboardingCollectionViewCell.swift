//
//  OnboardingCollectionViewCell.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 4.05.2019.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    static let CELL_IDENTIFIER = "OnboardingCollectionViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
}
