//
//  ConsumerDetailGeneralTableViewCell.swift
//  HoneySpot
//
//  Created by htcuser on 18/11/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class ConsumerDetailGeneralTableViewCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    var spotSaveModel : SpotSaveModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepareCell(spotSavemodel:SpotSaveModel){
        nameLabel.text = spotSavemodel.spot.name
        descriptionLabel.text = "\(spotSavemodel.spot.spotDescription.replace(string: "\\n", replacement: "\n"))"
        
    }

}
