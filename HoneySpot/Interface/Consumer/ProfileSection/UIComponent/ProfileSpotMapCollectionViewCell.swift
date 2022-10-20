//
//  ProfileSpotMapCollectionViewCell.swift
//  HoneySpot
//
//  Created by Max on 2/20/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit

class ProfileSpotMapCollectionViewCell: UICollectionViewCell, ProfileSpotCollectionViewProtocol {
    
    var cellImageView: UIImageView!
    var cellTagLabel: UILabel!
    var cellTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellImageView = UIImageView()
        cellTagLabel = UILabel()
        cellTitleLabel = UILabel()
    }

}
