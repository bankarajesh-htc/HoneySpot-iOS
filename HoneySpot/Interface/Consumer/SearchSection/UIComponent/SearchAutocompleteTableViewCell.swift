//
//  SearchAutocompleteTableViewCell.swift
//  HoneySpot
//
//  Created by Max on 2/22/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit

class SearchAutocompleteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var dataImageView: UIImageView!
    
    var data: Any? {
        didSet {
            guard let data = data else {
                return
            }
            if data is UserModel {
                let user = data as! UserModel
                self.dataImageView.kf.setImage(with: URL(string: user.pictureUrl ?? ""))
                self.dataLabel.text = user.username
            }else if data is SpotModel {
                let spot = data as! SpotModel
                self.dataImageView.image = UIImage(named:"IconSmallPlace")
				self.dataImageView.contentMode = .scaleAspectFill
                self.dataImageView.kf.setImage(with: URL(string: spot.photoUrl))
                if !spot.city.isEmpty {
                    self.dataLabel.text = String(format: "%@, %@", spot.name, spot.city)
                } else {
                    self.dataLabel.text = spot.name
                }
            }
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
