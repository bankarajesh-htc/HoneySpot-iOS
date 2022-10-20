//
//  InviteFriendsTableViewCell.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 11.11.2019.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit
import MessageUI

class InviteFriendsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var inviteButton: UIButton!
    var superVc : InviteFriendsViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func inviteTapped(_ sender: Any) {
        if(superVc != nil){
            superVc.sendSms(number: number.text ?? "")
        }
    }
    
    
    
}
