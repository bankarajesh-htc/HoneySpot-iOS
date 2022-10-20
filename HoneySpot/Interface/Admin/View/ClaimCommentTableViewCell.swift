//
//  ClaimCommentTableViewCell.swift
//  HoneySpot
//
//  Created by htcuser on 29/01/22.
//  Copyright © 2022 HoneySpot. All rights reserved.
//

import UIKit

class ClaimCommentTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var claimCommentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepareCell(model : SpotModel){
        //nameLabel.text = model.name
        claimCommentLabel.numberOfLines = 0
        claimCommentLabel.text = model.comment
    }

}
