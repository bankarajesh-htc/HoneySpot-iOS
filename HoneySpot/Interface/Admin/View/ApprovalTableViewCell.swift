//
//  ApprovalTableViewCell.swift
//  HoneySpot
//
//  Created by htcuser on 10/12/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class ApprovalTableViewCell: UITableViewCell {

    var cellDelegate: AdminApprovalStatusTableViewCellDelegate?
    @IBOutlet weak var approveButton: UIButton!
    @IBOutlet weak var rejectedButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func prepareCell() {
        
    }
    @IBAction func approveButtonPressed(_ sender: UIButton) {
        cellDelegate?.didTapStatus("Approve")
    }
    @IBAction func rejectButtonPressed(_ sender: UIButton) {
        cellDelegate?.didTapStatus("Reject")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
