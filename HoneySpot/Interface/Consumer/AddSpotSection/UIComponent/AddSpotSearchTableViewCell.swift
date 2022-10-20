//
//  AddSpotSearchTableViewCell.swift
//  HoneySpot
//
//  Created by Max on 4/5/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit
 

protocol AddSpotSearchTableViewCellDelegate {
    func didPressSaveSpotButton(_ sender: AddSpotSearchTableViewCell)
}

class AddSpotSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var spotNameLabel: UILabel!
    @IBOutlet weak var spotAddressLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    static let CELL_IDENTIFIER = "AddSpotSearchTableViewCell"
    var delegate: AddSpotSearchTableViewCellDelegate?
    
    var spot: SpotModel? {
        didSet {
            //self.avatarImage.layer.cornerRadius = self.avatarImage.frame.width / 2
            self.avatarImage.clipsToBounds = true
			if(self.spot?.photoUrl == ""){
				self.avatarImage.image = UIImage(named: "ImagePlaceholder")
			}else{
				self.avatarImage.kf.setImage(with: URL(string: self.spot?.photoUrl ?? ""))
			}
            self.spotNameLabel.text = self.spot?.name
            self.spotAddressLabel.text = self.spot?.address
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

    @IBAction func onSaveSpotButtonTap(_ sender: Any) {
        guard let delegate = self.delegate else {
            return
        }
        delegate.didPressSaveSpotButton(self)
    }
}
