//
//  BusinessSubscriptionTableViewCell.swift
//  HoneySpot
//
//  Created by htcuser on 09/11/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class BusinessSubscriptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var subcriptionOuterView: UIView!
    @IBOutlet weak var subcriptionNameLabel: UILabel!
    @IBOutlet weak var subcriptionPayment: UILabel!
    @IBOutlet weak var subcriptionMonthlyLabel: UILabel!
    @IBOutlet weak var featureLabel1: UILabel!
    @IBOutlet weak var featureLabel2: UILabel!
    @IBOutlet weak var featureLabel3: UILabel!
    @IBOutlet weak var selectionImage: UIImageView!
    @IBOutlet weak var descriptionView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
