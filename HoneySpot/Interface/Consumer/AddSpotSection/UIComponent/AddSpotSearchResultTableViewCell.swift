//
//  AddSpotSearchResultTableViewCell.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 13.11.2019.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit
 

class AddSpotSearchResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var claimButton: UIButton!
    
    var spot: SpotModel? {
        didSet {
            guard let spot = spot else {
                return
            }
            
            //self.img.layer.cornerRadius = self.img.frame.width / 2
            self.img.clipsToBounds = true
            self.name.adjustsFontSizeToFitWidth = true
            self.tags.text = "Tap to save"
            self.img.kf.setImage(with: URL(string: spot.photoUrl))
            self.name.text = spot.name
            self.tags.text = ""
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
