//
//  BaseTableViewCell.swift
//  HoneySpot
//
//  Created by htcuser on 07/09/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    var indexPath: IndexPath?

    override func configureWith(data: Any?, indexPath: IndexPath? = nil) {
        self.indexPath = indexPath
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

