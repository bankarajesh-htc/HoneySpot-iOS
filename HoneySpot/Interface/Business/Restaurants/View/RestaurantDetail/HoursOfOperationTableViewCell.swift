//
//  HoursOfOperationTableViewCell.swift
//  HoneySpot
//
//  Created by htcuser on 27/10/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class HoursOfOperationTableViewCell: UITableViewCell {

    @IBOutlet var dayNameLabel: UILabel!
    @IBOutlet var hoursLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
