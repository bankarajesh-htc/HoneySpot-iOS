//
//  SearchTableViewCell.swift
//  HoneySpot
//
//  Created by Max on 2/22/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var cellNumberLabel: UILabel!
    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var dataTitleLabel: UILabel!
    @IBOutlet weak var dataSubtitleLabel: UILabel!
    @IBOutlet weak var dataTypeImageView: UIImageView!
    var rowNumber: Int = -1
    var isComingFromTop: Int = -1
    
    var data: Any? {
        didSet {
            guard let data = data else {
                return
            }
            if data is UserModel {
                let userModel = data as! UserModel
                self.avatarView.imageView.image = UIImage(named:"AvatarPlaceholder")
                self.avatarView.userModel = userModel
                self.dataTitleLabel.text = userModel.username
                self.dataSubtitleLabel.text = userModel.fullname
                self.cellNumberLabel.isHidden = true
            } else if data is SpotModel {
                let spotModel = data as! SpotModel
                self.avatarView.imageView.frame = self.avatarView.containerView.bounds
                self.avatarView.imageView.image = UIImage(named: "logoSearch")
                self.avatarView.imageView.contentMode = .scaleAspectFill
                self.avatarView.spotModel = spotModel
                
                self.dataTitleLabel.text = spotModel.name
                self.dataSubtitleLabel.text = spotModel.city
                if self.isComingFromTop == 1 {
                    self.cellNumberLabel.text = String(format:"%ld", self.rowNumber + 1)
                }  else{
                    self.cellNumberLabel.isHidden = true
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
