//
//  ProfileSpotThinCollectionViewCell.swift
//  HoneySpot
//
//  Created by Max on 2/20/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit

class ProfileSpotThinCollectionViewCell: UICollectionViewCell, ProfileSpotCollectionViewProtocol {
    
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var cellTagLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
