//
//  TagCollectionViewCell.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 26.08.2019.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var tagImage: UIImageView!
    @IBOutlet weak var tagName: UILabel!
    @IBOutlet weak var selectedBackground: UIImageView!
    @IBOutlet weak var tagSelectedTick: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tagImage.image = nil
        tagName.text = ""
    }
}
