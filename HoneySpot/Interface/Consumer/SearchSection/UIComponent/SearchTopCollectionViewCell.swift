//
//  SearchTopCollectionViewCell.swift
//  HoneySpot
//
//  Created by Max on 2/22/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit

class SearchTopCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    func configureData(_ img: String, name: String) {
        self.img.layer.cornerRadius = 10
        self.img.clipsToBounds = true
        self.name.text = name
        self.img.image = UIImage(named: img)
    }

}
