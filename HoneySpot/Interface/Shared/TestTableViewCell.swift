//
//  TestTableViewCell.swift
//  HoneySpot
//
//  Created by htcuser on 07/09/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class TestTableViewCell: BaseTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override class func reuseById(content: Any?) -> String {
            return "TestTableViewCell"
    }
    override func configureWith(data: Any?, indexPath: IndexPath?) {

        print("Configure Data")
    }

        
}
